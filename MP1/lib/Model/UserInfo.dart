// ignore: file_names
import 'ProjectInfo.dart';

class UserInfo {
   String name;
   String position;
   String company;
   String phone;
   String email;
   String address1;
   String address2;

  // Each entry is a record with named fields that describe a degree
   List<Map<String, dynamic>> education;

  // Each entry is an instance of `ProjectInfo` that contains project details
   List<ProjectInfo> projects;

  UserInfo({
  required this.name, required this.position,
  required this.company, required this.phone, 
  required this.email, required this.address1,
  required this.address2,required this.education,
  required this.projects
  });
  static List< UserInfo > user = [];

   static void setUserInfo(){
    user.add(
      UserInfo(
      name: 'Elaine Fernandes',
      position: 'Software Engineer',
      company: 'Amazon',
      phone: '+1(312) 864-5429',
      email: 'elaine.fernandes@amazon.com',
      address1: '10 W 31st St.',
      address2: 'Chicago, IL 60616',
      education: [
        {'logo': 'assets/images/school.JPG', 'name': 'St. Charles High School', 'gpa': 3.8},
        {'logo': 'assets/images/college.png', 'name': 'Illinois Institute of Technology', 'gpa': 4.0},
        ],
      projects: [
        ProjectInfo(
          Imageurl: 'assets/images/library.jpg',
          projectDescription: 'Bookstore Management System',
        ),
        ProjectInfo(
          Imageurl: 'assets/images/gaming.jpg',
          projectDescription: 'Gaming App',           
        ),
         ProjectInfo(
          Imageurl: 'assets/images/news feed.jpg',
          projectDescription: 'News Feed App',        
        ),
         ProjectInfo(
          Imageurl: 'assets/images/healthcare.JPG',
          projectDescription: 'Healthcare Management System',
        ),
        ProjectInfo(
          Imageurl: 'assets/images/project.jpg',
          projectDescription: 'Internet of Things',
        ),
        ProjectInfo(
          Imageurl: 'assets/images/food tracker.jpg',
          projectDescription: 'Food Delivery App',
        ),
    ],
  ),
);
}

   static List<UserInfo> getUserInfo(){
    setUserInfo();
    return user;
  }
}