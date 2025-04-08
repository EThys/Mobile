import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Elevata',
          style: GoogleFonts.poppins(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.deepPurple),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.deepPurple),
            onPressed: () {},
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroBanner(),
            //_buildQuickActions(),
            _buildSectionHeader("Catégories"), // Categories
            _buildCategories(),
            _buildSectionHeader(
              "Campagnes Urgentes",
              onSeeAll: () {

            },),
            _buildUrgentCampaigns(),
            SizedBox(height: 5,),
            _buildSectionHeader(
              "Nos Réussites",
              onSeeAll: () {
                // Navigation vers la page qui montre toutes les campagnes

              },
            ),
            _buildSuccessStories(),
            _buildSectionHeader(
                "Campagnes en vedette",
                onSeeAll: () {

                },
            ),
            SizedBox(height: 5,),
            _buildFeaturedCampaigns(),


            _buildSectionHeader(
              "Dons récents",
              onSeeAll: () {


              },
            ),
            _buildRecentDonations(),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildHeroBanner() {
    return Container(
      margin: EdgeInsets.all(16),
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.deepPurple, Colors.purpleAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            bottom: -30,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                FontAwesomeIcons.handsHelping,
                size: 180,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Faites la différence',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Soutenez des causes qui vous tiennent à cœur',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      'Commencer à donner',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(
            icon: FontAwesomeIcons.searchDollar,
            label: 'Trouver',
            color: Colors.blue,
          ),
          _buildActionButton(
            icon: FontAwesomeIcons.plusCircle,
            label: 'Créer',
            color: Colors.green,
          ),
          _buildActionButton(
            icon: FontAwesomeIcons.handHoldingHeart,
            label: 'Donner',
            color: Colors.orange,
          ),
          _buildActionButton(
            icon: FontAwesomeIcons.shareAlt,
            label: 'Partager',
            color: Colors.pink,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(12),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessStories() {
    final stories = [
      {
        'title': 'École reconstruite',
        'description': 'Grâce à vos dons, 150 enfants ont retrouvé leur école',
        'image': 'assets/image1.jpg',
        'raised': '45,000€',
      },
      {
        'title': 'Puits en Afrique',
        'description': '3 villages ont maintenant accès à l\'eau potable',
        'image': 'assets/image2.jpg',
        'raised': '28,000€',
      },
    ];

    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: stories.length,
        itemBuilder: (context, index) {
          return Container(
            width: 280,
            margin: EdgeInsets.only(right: 16),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      stories[index]['image']!,
                      height: 200,
                      width: 280,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stories[index]['title']!,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          stories[index]['description']!,
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Objectif atteint: ${stories[index]['raised']}',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }




  Widget _buildUrgentCampaigns() {
    final urgentCampaigns = [
      {
        'title': 'Urgence Médicale - Enfant',
        'organization': 'Hôpital des Enfants',
        'progress': 0.45,
        'amount': '9,000€',
        'goal': '20,000€',
        'daysLeft': 3,
        'image': 'assets/image1.jpg',
        'urgent': true,
      },
      {
        'title': 'Catastrophe Naturelle',
        'organization': 'Croix Rouge',
        'progress': 0.25,
        'amount': '25,000€',
        'goal': '100,000€',
        'daysLeft': 5,
        'image': 'assets/image2.jpg',
        'urgent': true,
      },
    ];

    return Container(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: urgentCampaigns.length,
        itemBuilder: (context, index) {
          return Container(
            width: 220,
            margin: EdgeInsets.only(right: 16),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              color: Colors.red[50], // Fond légèrement rouge pour urgence
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.asset(
                          urgentCampaigns[index]['image'] as String,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.error_outline, color: Colors.red, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  'URGENT',
                                  style: GoogleFonts.poppins(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              urgentCampaigns[index]['title'] as String,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // ... (reste comme _buildFeaturedCampaigns)
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${urgentCampaigns[index]['daysLeft']} JOURS',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }




  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Voir plus',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.deepPurple,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }






  Widget _buildFeaturedCampaigns() {
    final campaigns = [
      {
        'title': 'Éducation pour tous',
        'organization': 'Fondation ABC',
        'progress': 0.65,
        'amount': '32,500€',
        'goal': '50,000€',
        'daysLeft': 12,
        'image': 'assets/image2.jpg',
      },
      {
        'title': 'Aide aux sans-abri',
        'organization': 'Association Solidarité',
        'progress': 0.35,
        'amount': '7,000€',
        'goal': '20,000€',
        'daysLeft': 24,
        'image': 'assets/image1.jpg',
      },
      {
        'title': 'Protection des animaux',
        'organization': 'Refuge Animalier',
        'progress': 0.82,
        'amount': '41,000€',
        'goal': '50,000€',
        'daysLeft': 5,
        'image': 'assets/image2.jpg',
      },
    ];

    return Container(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: campaigns.length,
        itemBuilder: (context, index) {
          return Container(
            width: 220,
            margin: EdgeInsets.only(right: 16),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.asset(
                      campaigns[index]['image'] as String,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          campaigns[index]['title'] as String,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          campaigns[index]['organization'] as String,
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: campaigns[index]['progress'] as double,
                          backgroundColor: Colors.grey[200],
                          color: Colors.deepPurple,
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${campaigns[index]['amount']}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${campaigns[index]['daysLeft']} jours',
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategories() {
    final categories = [
      {'icon': FontAwesomeIcons.heart, 'label': 'Santé', 'color': Colors.red},
      {'icon': FontAwesomeIcons.graduationCap, 'label': 'Éducation', 'color': Colors.blue},
      {'icon': FontAwesomeIcons.home, 'label': 'Logement', 'color': Colors.green},
      {'icon': FontAwesomeIcons.paw, 'label': 'Animaux', 'color': Colors.orange},
      {'icon': FontAwesomeIcons.globe, 'label': 'Environnement', 'color': Colors.teal},
    ];

    return Container(
      height: 70,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Container(
            width: 80,
            margin: EdgeInsets.only(right: 12),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: categories[index]['color'] as Color,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: (categories[index]['color'] as Color).withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    categories[index]['icon'] as IconData,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  categories[index]['label'] as String,
                  style: GoogleFonts.poppins(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentDonations() {
    final donations = [
      {'name': 'Jean D.', 'amount': '50€', 'time': '2 min', 'campaign': 'Aide alimentaire'},
      {'name': 'Marie L.', 'amount': '100€', 'time': '15 min', 'campaign': 'Éducation'},
      {'name': 'Pierre T.', 'amount': '25€', 'time': '1h', 'campaign': 'Refuge animalier'},
      {'name': 'Sophie M.', 'amount': '75€', 'time': '2h', 'campaign': 'Médical'},
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: donations.map((donation) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.deepPurple[100],
                      child: Text(
                        donation['name']!.substring(0, 1),
                        style: GoogleFonts.poppins(color: Colors.deepPurple),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            donation['name']!,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            donation['campaign']!,
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          donation['amount']!,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          donation['time']!,
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}