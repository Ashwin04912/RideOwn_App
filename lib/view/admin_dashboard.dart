import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mini_pro_app/models/user_data/user_data_model.dart';
import 'package:mini_pro_app/view_model/controller/admin_dashboard_controller.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // Create a DateFormat instance for formatting
  final dashBoardController = Get.put(AdminDashboardController());
  final DateFormat dateFormatter = DateFormat('MMM dd, yyyy - hh:mm a');

  @override
  void initState() {
    super.initState();
    // Load data when the widget initializes
    dashBoardController.loadDetails();
  }

  String formatTimestamp(DateTime timestamp) {
    try {
      return dateFormatter.format(timestamp);
    } catch (e) {
      return "N/A";
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'on-ride':
        return Colors.amber;
      case 'returned':
        return Colors.green;
      case 'overdue':
        return Colors.red;
      case 'reserved':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        cardColor: const Color(0xFF1A1A1A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF101010),
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Colors.indigo,
          secondary: Colors.indigoAccent,
          surface: Color(0xFF1A1A1A),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Row(
            children: [
              Icon(Icons.directions_bike, size: 28),
              SizedBox(width: 12),
              Text(
                'Cycle Admin',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                dashBoardController.loadDetails();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Refreshing data...'),
                    backgroundColor: Colors.indigo,
                  ),
                );
              },
            ),
           
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              onPressed: () {
                _showLogoutDialog();
              },
            ),
          ],
        ),
        body: Obx(() {
          if (dashBoardController.loading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (dashBoardController.userData.value == null) {
            return const Center(child: Text('No data available'));
          }

          return Column(
            children: [
              _buildDashboardSummary(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: dashBoardController.userData.value!.users.length,
                  itemBuilder: (context, index) {
                    final userKey = dashBoardController
                        .userData.value!.users.keys
                        .elementAt(index);
                    return _buildUserCard(
                        dashBoardController.userData.value!.users[userKey]!);
                  },
                ),
              ),
            ],
          );
        }),
    
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF252525),
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
              ),
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop();
                // Add logout functionality here
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDashboardSummary() {
    // Count users by status
    int onRideCount = 0;
    int returnedCount = 0;

    if (dashBoardController.userData.value?.isAvailable == true) {
      onRideCount = onRideCount + 1;
    } else {
     
      returnedCount++;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF101010),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dashboard Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Real-time Monitoring',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSummaryCard(
                title: 'Total Users',
                value:
                    dashBoardController.userData.value!.users.length.toString(),
                icon: Icons.people,
                color: Colors.indigoAccent,
              ),
                _buildSummaryCard(
                title: 'Available',
                value: returnedCount.toString(),
                icon: Icons.check_circle,
                color: Colors.green,
              ),
              _buildSummaryCard(
                title: 'On Ride',
                value: onRideCount.toString(),
                icon: Icons.pedal_bike,
                color: Colors.amber,
              ),
            
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        color: const Color(0xFF1E1E1E),
        shadowColor: Colors.black26,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color.withOpacity(0.3), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                  Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.arrow_upward,
                      color: color,
                      size: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(User user) {
    final statusColor = getStatusColor(user.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shadowColor: Colors.black38,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: statusColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.2),
          child: Text(
            user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          user.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              margin: const EdgeInsets.only(right: 8, top: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: statusColor,
                  width: 1,
                ),
              ),
              child: Text(
                user.status,
                style: TextStyle(
                  fontSize: 12,
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF151515),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              border: Border(
                top: BorderSide(
                  color: Colors.grey.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'User Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
                const Divider(color: Colors.grey, height: 24),
                _buildDetailRow(
                  icon: Icons.email,
                  title: 'Email',
                  value: user.email,
                ),
                _buildDetailRow(
                  icon: Icons.phone,
                  title: 'Phone',
                  value: user.phone,
                ),
                _buildDetailRow(
                  icon: Icons.password,
                  title: 'OTP',
                  value: user.otp,
                ),
                _buildDetailRow(
                  icon: Icons.school,
                  title: 'Year',
                  value: user.year,
                ),
                _buildDetailRow(
                  icon: Icons.access_time,
                  title: 'Taken time',
                  value: formatTimestamp(user.timestamp),
                ),
                _buildDetailRow(
                  icon: Icons.access_time,
                  title: 'Return time',
                  value: formatTimestamp(user.timestamp),
                ),
                const SizedBox(height: 16),
                              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              size: 20,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
