import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateCampaignPage extends StatefulWidget {
  @override
  _CreateCampaignPageState createState() => _CreateCampaignPageState();
}

class _CreateCampaignPageState extends State<CreateCampaignPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _goalController = TextEditingController();
  final _organizationController = TextEditingController();
  final _urgencyReasonController = TextEditingController();
  final _mobileMoneyController = TextEditingController();

  DateTime? _endDate;
  String _selectedCategory = 'Santé';
  String _selectedCurrency = 'EUR';
  List<File> _selectedImages = [];
  bool _isUrgent = false;
  bool _isSubmitting = false;

  // Payment information
  String _selectedPaymentMethod = 'Bank';
  String? _bankName;
  String? _accountNumber;
  String? _accountName;
  String? _iban;
  String? _swiftCode;
  List<Map<String, String>> _mobileMoneyNumbers = [];
  String? _selectedMobileMoneyProvider;

  final List<String> _mobileMoneyProviders = [
    'Orange Money',
    'Airtel Money',
    'M-Pesa',
    'Afrimoney'
  ];

  final ImagePicker _picker = ImagePicker();
  final List<String> _categories = [
    'Santé',
    'Éducation',
    'Environnement',
    'Animaux',
    'Urgence humanitaire',
    'Culture',
    'Développement'
  ];

  final List<String> _currencies = ['EUR', 'USD', 'XAF', 'CAD', 'CHF'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _goalController.dispose();
    _organizationController.dispose();
    _urgencyReasonController.dispose();
    _mobileMoneyController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _endDate)
      setState(() {
        _endDate = picked;
      });
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile>? images = await _picker.pickMultiImage(
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (images != null && images.isNotEmpty) {
        if (_selectedImages.length + images.length > 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Vous ne pouvez sélectionner que 5 images maximum'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        setState(() {
          _selectedImages.addAll(images.map((xfile) => File(xfile.path)));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la sélection des images: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _addMobileMoneyNumber() {
    if (_mobileMoneyController.text.isEmpty || _selectedMobileMoneyProvider == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez sélectionner un opérateur et entrer un numéro'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _mobileMoneyNumbers.add({
        'provider': _selectedMobileMoneyProvider!,
        'number': _mobileMoneyController.text,
      });
      _mobileMoneyController.clear();
      _selectedMobileMoneyProvider = null;
    });
  }

  void _removeMobileMoneyNumber(int index) {
    setState(() {
      _mobileMoneyNumbers.removeAt(index);
    });
  }

  IconData _getMobileMoneyIcon(String provider) {
    switch (provider) {
      case 'Orange Money':
        return FontAwesomeIcons.moneyBillAlt;
      case 'Airtel Money':
        return FontAwesomeIcons.signal;
      case 'M-Pesa':
        return FontAwesomeIcons.moneyBillWave;
      case 'Afrimoney':
        return FontAwesomeIcons.moneyBillAlt;
      default:
        return Icons.phone_android;
    }
  }

  Color _getMobileMoneyColor(String provider) {
    switch (provider) {
      case 'Orange Money':
        return Colors.orange;
      case 'Airtel Money':
        return Colors.red;
      case 'M-Pesa':
        return Colors.green;
      case 'Afrimoney':
        return Colors.blue;
      default:
        return Colors.deepPurple;
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez ajouter au moins une image'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_isUrgent && _urgencyReasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez expliquer pourquoi la campagne est urgente'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedPaymentMethod == 'Bank' &&
        (_bankName == null || _bankName!.isEmpty ||
            _accountName == null || _accountName!.isEmpty ||
            _accountNumber == null || _accountNumber!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez remplir tous les champs obligatoires pour les coordonnées bancaires'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedPaymentMethod == 'MobileMoney' && _mobileMoneyNumbers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez ajouter au moins un numéro Mobile Money'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await Future.delayed(Duration(seconds: 2));

      print({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'goal': _goalController.text,
        'currency': _selectedCurrency,
        'category': _selectedCategory,
        'endDate': _endDate,
        'organization': _organizationController.text,
        'isUrgent': _isUrgent,
        'urgencyReason': _urgencyReasonController.text,
        'images': _selectedImages.length,
        'paymentMethod': _selectedPaymentMethod,
        'bankDetails': _selectedPaymentMethod == 'Bank' ? {
          'bankName': _bankName,
          'accountName': _accountName,
          'accountNumber': _accountNumber,
          'iban': _iban,
          'swiftCode': _swiftCode,
        } : null,
        'mobileMoneyNumbers': _selectedPaymentMethod == 'MobileMoney'
            ? _mobileMoneyNumbers
            : null,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Campagne soumise avec succès ! Elle sera publiée après validation par notre équipe.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 5),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la soumission: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvelle Campagne',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _submitForm,
            child: _isSubmitting
                ? CircularProgressIndicator(color: Colors.deepPurple)
                : Text('SOUMETTRE',
                style: GoogleFonts.poppins(
                    color: Colors.deepPurple, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avertissement validation
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[800]),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Votre campagne sera examinée par notre équipe avant publication (24-48h)',
                        style: GoogleFonts.poppins(
                          color: Colors.blue[800],
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Section Images
              _buildImageUploadSection(),
              SizedBox(height: 24),

              // Titre
              Text('Titre de la campagne*',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
              SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Ex: Aide aux enfants défavorisés',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value!.isEmpty ? 'Ce champ est obligatoire' : null,
              ),
              SizedBox(height: 20),

              // Description
              Text('Description détaillée*',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
              SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Décrivez en détail votre campagne...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) =>
                value!.isEmpty ? 'Ce champ est obligatoire' : null,
              ),
              SizedBox(height: 20),

              // Objectif financier
              Text('Objectif financier*',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _goalController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        prefixText: '   ',
                        suffixText: _selectedCurrency,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? 'Ce champ est obligatoire' : null,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<String>(
                      value: _selectedCurrency,
                      items: _currencies
                          .map((currency) => DropdownMenuItem(
                        value: currency,
                        child: Text(currency),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCurrency = value!;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Catégorie
              Text('Catégorie*',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories
                    .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // Date de fin
              Text('Date de fin*',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
              SizedBox(height: 8),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _endDate != null
                            ? DateFormat('dd/MM/yyyy').format(_endDate!)
                            : 'Sélectionnez une date',
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(Icons.calendar_today, color: Colors.deepPurple),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Organisation
              Text('Organisation',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
              SizedBox(height: 8),
              TextFormField(
                controller: _organizationController,
                decoration: InputDecoration(
                  hintText: 'Nom de votre organisation (optionnel)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // Campagne urgente
              SwitchListTile(
                title: Text('Marquer comme campagne urgente',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                subtitle: Text('Les campagnes urgentes sont mises en avant'),
                activeColor: Colors.deepPurple,
                value: _isUrgent,
                onChanged: (value) {
                  setState(() {
                    _isUrgent = value;
                  });
                },
              ),

              // Raison de l'urgence (conditionnel)
              if (_isUrgent) ...[
                SizedBox(height: 16),
                Text('Pourquoi cette campagne est-elle urgente ?*',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                SizedBox(height: 8),
                TextFormField(
                  controller: _urgencyReasonController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Expliquez la situation urgente...',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) => _isUrgent && value!.isEmpty
                      ? 'Veuillez expliquer l\'urgence'
                      : null,
                ),
                SizedBox(height: 8),
                Text(
                  'Notre équipe vérifiera votre demande sous 24h',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],

              // Section Coordonnées bancaires/Mobile Money
              SizedBox(height: 30),
              Text('Coordonnées de paiement*',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
              SizedBox(height: 8),
              Text('Comment souhaitez-vous recevoir les fonds collectés ?',
                  style: TextStyle(color: Colors.grey)),
              SizedBox(height: 12),

              // Sélection de la méthode de paiement
              DropdownButtonFormField<String>(
                value: _selectedPaymentMethod,
                items: [
                  DropdownMenuItem(
                    value: 'Bank',
                    child: Text('Compte bancaire'),
                  ),
                  DropdownMenuItem(
                    value: 'MobileMoney',
                    child: Text('Mobile Money'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              SizedBox(height: 20),

              // Section conditionnelle pour les coordonnées bancaires
              if (_selectedPaymentMethod == 'Bank') ...[
                TextFormField(
                  onChanged: (value) => _bankName = value,
                  decoration: InputDecoration(
                    labelText: 'Nom de la banque*',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => _selectedPaymentMethod == 'Bank' && value!.isEmpty
                      ? 'Ce champ est obligatoire'
                      : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  onChanged: (value) => _accountName = value,
                  decoration: InputDecoration(
                    labelText: 'Nom du titulaire du compte*',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => _selectedPaymentMethod == 'Bank' && value!.isEmpty
                      ? 'Ce champ est obligatoire'
                      : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  onChanged: (value) => _accountNumber = value,
                  decoration: InputDecoration(
                    labelText: 'Numéro de compte*',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => _selectedPaymentMethod == 'Bank' && value!.isEmpty
                      ? 'Ce champ est obligatoire'
                      : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  onChanged: (value) => _iban = value,
                  decoration: InputDecoration(
                    labelText: 'IBAN (optionnel)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  onChanged: (value) => _swiftCode = value,
                  decoration: InputDecoration(
                    labelText: 'Code SWIFT/BIC (optionnel)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],

              // Section conditionnelle pour Mobile Money
              if (_selectedPaymentMethod == 'MobileMoney') ...[
                Text('Ajouter jusqu\'à 4 numéros Mobile Money',
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                SizedBox(height: 12),

                // Liste des numéros déjà ajoutés
                if (_mobileMoneyNumbers.isNotEmpty) ...[
                  ..._mobileMoneyNumbers.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, String> item = entry.value;
                    return Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(_getMobileMoneyIcon(item['provider']!),
                              color: _getMobileMoneyColor(item['provider']!)),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['provider']!,
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(item['number']!),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeMobileMoneyNumber(index),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 12),
                ],

                // Formulaire pour ajouter un nouveau numéro
                if (_mobileMoneyNumbers.length < 4) ...[
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          value: _selectedMobileMoneyProvider,
                          items: _mobileMoneyProviders
                              .map((provider) => DropdownMenuItem(
                            value: provider,
                            child: Text(provider),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedMobileMoneyProvider = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Opérateur',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: _mobileMoneyController,
                          decoration: InputDecoration(
                            labelText: 'Numéro*',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: _addMobileMoneyNumber,
                      icon: Icon(Icons.add, size: 18),
                      label: Text('Ajouter ce numéro'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple[50],
                        foregroundColor: Colors.deepPurple,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],

                // Validation pour Mobile Money
                if (_mobileMoneyNumbers.isEmpty && _selectedPaymentMethod == 'MobileMoney')
                  Text(
                    'Veuillez ajouter au moins un numéro Mobile Money',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
              ],

              SizedBox(height: 30),

              // Bouton de soumission
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  child: _isSubmitting
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('SOUMETTRE LA CAMPAGNE',
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Images de la campagne*',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        Text('Ajoutez au moins une image (max 5)',
            style: TextStyle(color: Colors.grey)),
        SizedBox(height: 12),
        Container(
          height: 180,
          child: _selectedImages.isEmpty
              ? GestureDetector(
            onTap: _pickImages,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo,
                      size: 40, color: Colors.grey[400]),
                  SizedBox(height: 8),
                  Text('Ajouter des images',
                      style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
          )
              : GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: _selectedImages.length + (_selectedImages.length < 5 ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < _selectedImages.length) {
                return Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(_selectedImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 12,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.close,
                              size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return GestureDetector(
                  onTap: _pickImages,
                  child: Container(
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo,
                            size: 30, color: Colors.grey[400]),
                        SizedBox(height: 4),
                        Text('Ajouter',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}