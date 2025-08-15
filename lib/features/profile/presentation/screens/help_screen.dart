import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenterScreen extends StatelessWidget {
  final String supportEmail = 'support@rootercab.com';
  final String supportPhone = '+91 9910213793';
  final String whatsappNumber = '+91 9910213793';

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          // Modern App Bar with Better Spacing
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            expandedHeight: 120,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 20, bottom: 16),
              title: Text('Help Center'),
            ),
          ),

          // Support Options with Better Spacing
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 0), // Adjusted padding
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSupportOption(
                      icon: Icons.phone,
                      title: 'Call Support',
                      subtitle: supportPhone,
                      color: Colors.blue[100]!,
                      iconColor: Colors.blue,
                      onTap: () => _launchURL('tel:$supportPhone'),
                    ),
                    Divider(
                        height: 1,
                        indent: 70,
                        endIndent: 20), // Adjusted divider
                    _buildSupportOption(
                      icon: Icons.email_outlined,
                      title: 'Email Support',
                      subtitle: supportEmail,
                      color: Colors.orange[100]!,
                      iconColor: Colors.orange,
                      onTap: () => _launchURL('mailto:$supportEmail'),
                    ),
                    Divider(
                        height: 1,
                        indent: 70,
                        endIndent: 20), // Adjusted divider
                    _buildSupportOption(
                      icon: Icons.chat_bubble_outline,
                      title: 'WhatsApp Support',
                      subtitle: whatsappNumber,
                      color: Colors.green[100]!,
                      iconColor: Colors.green,
                      onTap: () => _launchURL('https://wa.me/$whatsappNumber'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // FAQ Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 15),
              child: Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),

          // FAQ List
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final faq = faqItems[index];
                return Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      title: Text(
                        faq['question']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      trailing: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.orange,
                          size: 20,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 15),
                          child: Text(
                            faq['answer']!,
                            style: TextStyle(
                              color: Colors.grey[600],
                              height: 1.5,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: faqItems.length,
            ),
          ),

          // Bottom Padding
          SliverPadding(padding: EdgeInsets.only(bottom: 30)),
        ],
      ),
    );
  }

  Widget _buildSupportOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 20, vertical: 16), // Adjusted padding
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            SizedBox(width: 16), // Increased spacing
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[300], size: 16),
          ],
        ),
      ),
    );
  }

  final List<Map<String, String>> faqItems = [
    {
      'question': 'How do I change my password?',
      'answer':
          'Go to Settings > Security > Change Password. Follow the prompts to enter your current password and set a new one.',
    },
    {
      'question': 'How to cancel a booking?',
      'answer':
          'Open your active bookings, select the booking you want to cancel, and tap the "Cancel Booking" button. Please note our cancellation policy.',
    },
    {
      'question': 'Payment methods accepted?',
      'answer':
          'We accept credit/debit cards, PayPal, and mobile wallets. All payments are processed securely through our platform.',
    },
    {
      'question': 'Is my data secure?',
      'answer':
          'Yes, we use industry-standard encryption and security measures to protect your personal information and transaction data.',
    },
  ];
}

class FAQTab extends StatelessWidget {
  final List<Map<String, String>> faqItems = [
    {
      'question': 'What if I need to cancel a booking?',
      'answer':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    },
    {
      'question': 'Is it safe to use the app?',
      'answer':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    },
    {
      'question': 'How do I receive booking details?',
      'answer':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    },
    {
      'question': 'How can I edit my profile information?',
      'answer':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    },
    {
      'question': 'How to cancel a taxi?',
      'answer':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    },
    {
      'question': 'How to add a new car?',
      'answer':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    },
    {
      'question': 'How to see pre-booked taxis?',
      'answer':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
          SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip('All', true),
                _buildCategoryChip('Services', false),
                _buildCategoryChip('General', false),
                _buildCategoryChip('Account', false),
              ],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: faqItems.map((item) {
                return ExpansionTile(
                  title: Text(item['question']!),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(item['answer']!),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          // Handle chip selection
        },
        selectedColor: Colors.orange,
        backgroundColor: Colors.grey[200],
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}

class ContactUsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildContactItem(Icons.phone, 'Phone', '9910213793'),
          _buildContactItem(Icons.email, 'Email', 'info@rootercab.com'),
          _buildContactItem(Icons.location_on, 'Address',
              '1234 Elm Street, Springfield, IL 62704'),
        ],
      ),
    );
  }
}

Widget _buildContactItem(IconData icon, String title, [String subtitle = '']) {
  return ExpansionTile(
    leading: Icon(icon, color: Colors.orange),
    title: Text(title),
    children: [ListTile(title: Text(subtitle))],
  );
}
