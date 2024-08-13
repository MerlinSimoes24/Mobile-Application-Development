import 'package:cs442_mp1/Model/ProjectInfo.dart';
import 'package:flutter/material.dart';
import 'package:cs442_mp1/Model/UserInfo.dart';

class UserInfoPage extends StatelessWidget {
  final UserInfo userInfo;

  const UserInfoPage({required this.userInfo, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: const Color.fromARGB(255, 228, 151, 57),
      ),
      body: Container(
        color: const Color.fromARGB(255, 145, 198, 222),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserInfoSection(userInfo: userInfo),
              const SizedBox(height: 24.0),
              ContactInfo(userInfo: userInfo),
              const SizedBox(height: 24.0),
              EducationSection(education: userInfo.education),
              const SizedBox(height: 24.0),
              ProjectsSection(projects: userInfo.projects),
            ],
          ),
        ),
      ),
    );
  }
}

class UserInfoSection extends StatelessWidget {
  final UserInfo userInfo;

  const UserInfoSection({required this.userInfo, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          radius: 70,
          backgroundImage: AssetImage('assets/images/elaineimage.png'),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '  ${userInfo.name}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                '  ${userInfo.position}',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                '  ${userInfo.company}',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ContactInfo extends StatelessWidget {
  final UserInfo userInfo;

  const ContactInfo({required this.userInfo, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Contact Information',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ContactRow(
          iconPath: 'assets/images/cell.jpg',
          contactText: userInfo.phone,
        ),
        const SizedBox(height: 24.0),
        ContactRow(
          iconPath: 'assets/images/mail.jpg',
          contactText: userInfo.email,
        ),
        const SizedBox(height: 24.0),
        ContactRow(
          iconPath: 'assets/images/home.jpg',
          contactText: '${userInfo.address1}, ${userInfo.address2}',
        ),
      ],
    );
  }
}


class ContactRow extends StatelessWidget {
  final String iconPath;
  final String contactText;

  const ContactRow({required this.iconPath, required this.contactText, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(iconPath, width: 70), // Adjust the size as needed
        const SizedBox(width: 16.0),
        Expanded(child: Text(contactText, style: const TextStyle(fontSize: 16))),
      ],
    );
  }
}


class EducationSection extends StatelessWidget {
  final List<Map<String, dynamic>> education;

  const EducationSection({required this.education});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Education', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: education.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Image.asset(education[index]['logo']),
              title: Text(education[index]['name']),
              subtitle: Text('GPA: ${education[index]['gpa']}'),
            );
          },
        ),
      ],
    );
  }
}

class ProjectsSection extends StatelessWidget {
  final List<ProjectInfo> projects;

  const ProjectsSection({required this.projects, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the rows with the 'Projects' header
    List<Widget> rows = [
      Padding(
        padding: const EdgeInsets.only(bottom: 16.0), // Add some space below the header
        child: const Text(
          'Projects',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    ];

    for (int i = 0; i < projects.length; i += 3) {
      List<Widget> rowChildren = [];
      for (int j = i; j < i + 3 && j < projects.length; j++) {
        rowChildren.add(
          Column(
            children: [
              Image.asset(projects[j].Imageurl, width: 100, height: 100),
              Text(projects[j].projectDescription),
            ],
          ),
        );
        if (j < i + 2) {
          rowChildren.add(SizedBox(width: 8)); // Add spacing between columns if it's not the last item
        }
      }
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rowChildren,
      ));
      if (i + 3 < projects.length) {
        rows.add(SizedBox(height: 100)); // Add spacing between rows
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }
}