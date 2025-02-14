
import 'package:flutter/material.dart';
import 'package:nexdoor/core/responsive/responsive.dart';
import 'package:nexdoor/features/auth/models/user.dart';
import 'package:nexdoor/features/auth/repositories/auth_repository.dart';
import 'package:nexdoor/features/settings_profile/repositories/user_repository.dart';
import 'package:nexdoor/widgets/c_button_widget.dart';
import 'package:nexdoor/widgets/c_form_field.dart';


class EditUserScreen extends StatelessWidget {
  const EditUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return const MobileEditUserScreen();
    } else {
      return const DeskTopEditUserScreen();
    }
  }
}

// Mobile screen
class MobileEditUserScreen extends StatelessWidget {
  const MobileEditUserScreen({super.key});
  @override
  Widget build(BuildContext context) {
   
    return const Scaffold(
      backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: EditUserWidget(isDesktop: false),
        );
  }
}

// Desktop screen
class DeskTopEditUserScreen extends StatelessWidget {
  const DeskTopEditUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
         Flexible(flex: 3, child: SizedBox(width: double.infinity)),
              Flexible(flex: 3, child:
                          EditUserWidget(
              isDesktop: true,
            )),
              Flexible(flex: 3, child: SizedBox(width: double.infinity)),
        
      ],
    );
  }
}

class EditUserWidget extends StatefulWidget {
  const EditUserWidget({super.key, required this.isDesktop});
  final bool isDesktop;
  @override
  State<EditUserWidget> createState() => _EditUserWidgetState();
}

class _EditUserWidgetState extends State<EditUserWidget> {
  final currentYear = DateTime.now().year;
  final _formKey = GlobalKey<FormState>();
  bool isUploading = false;
  String name = "";
  String programme = "";
  String bio = "";
  String passingYear = "";
  final List<String> programmes = [
    "",
    "B.Com - Computer Application",
    "B.Com Finance",
    "B.Com Professional",
    "B.Com. Honours",
    "B.Sc. Botany",
    "B.Sc. Chemistry",
    "B.Sc. Computer Science",
    "B.Sc. Computer Science & Mathematics (Double Main)",
    "B.Sc. Economics and Mathematics (Double Main)",
    "B.Sc. Honours in Mathematics",
    "B.Sc. Mathematics",
    "B.Sc. Physics",
    "B.Sc. Psychology",
    "B.Sc. Zoology",
    "BA Animation and Graphic Design",
    "BA Economics",
    "BA English Language and Literature",
    "BA Functional English",
    "BA Journalism and Mass Communication",
    "BBA (Honours)",
    "Bachelor of Business Administration (BBA)",
    "Bachelor of Computer Application",
    "Bachelor of Sports Management",
    "M A English Language and Literature",
    "M.Com",
    "M.Sc Psychology",
    "M.Sc. Botany",
    "M.Sc. Chemistry",
    "M.Sc. Computer Science",
    "M.Sc. Mathematics",
    "M.Sc. Physics",
    "M.Sc. Statistics",
    "M.Sc. Zoology",
    "MA Economics",
    "MA Malayalam Language and Literature",
    "Master of Social Work (MSW)",
  ];
  fetchuserInfo() async {
    try {
      UserDataService us = UserDataService();
      UserModel currentUserInfo = await us.fetchCurrentUserInfo();
      name = currentUserInfo.name ?? "";
      return currentUserInfo;
    } catch (e, s) {
      errorNotifier("fetchuserInfo()", e, s);
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    List<String> years = [
      "",
      currentYear.toString(),
      (currentYear + 1).toString(),
      (currentYear + 2).toString(),
      (currentYear + 3).toString(),
      (currentYear + 4).toString(),
    ];
    return Container(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          margin: widget.isDesktop
              ? null
              : const EdgeInsets.symmetric(vertical: 60, horizontal: 25),
          decoration: BoxDecoration(
              color: color.primary,
              border: widget.isDesktop
                  ? null
                  : Border.all(color: color.inversePrimary),
              borderRadius:
                  widget.isDesktop ? null : BorderRadius.circular(10)),
          child: FutureBuilder(
            future: fetchuserInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 4.0, // Adjust thickness if necessary
                    backgroundColor: Colors.transparent,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(color.inversePrimary),
                  ),
                );
              } else if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Complete your profile",
                        style: TextStyle(fontSize: 30),
                      ),
                      const SizedBox(height: 40),
                      Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              CustomField(
                                prefixIcon: const Icon(Icons.person_2_outlined),
                                title: "Full name",
                                subtitle: "Enter your full name",
                                initialValue: name,
                                onSaved: (value) {
                                  name = value ?? "";
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return "Enter your full name";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              const SizedBox(height: 10),
                              CustomField(
                                prefixIcon: const Icon(Icons.subject_rounded),
                                title: "Bio",
                                subtitle: "Write about yourself in a sentence",
                                initialValue: bio ==
                                        "Bio under construction... please check back later! 🚧"
                                    ? ""
                                    : bio,
                                onSaved: (value) {
                                  bio = value == "" ||
                                          value == " " ||
                                          value == null
                                      ? "Bio under construction... please check back later! 🚧"
                                      : (value);
                                },
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Programme",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 14),
                              ),
                              const SizedBox(height: 5),
                              DropdownButtonFormField<String>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  hintText: "Select Programme",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  prefixIcon: const Icon(Icons.class_),
                                  prefixIconColor:
                                      color.inversePrimary.withValues(alpha:0.3),
                                  labelStyle: TextStyle(
                                      color: color.inversePrimary,
                                      fontSize: 20),
                                  hintStyle: TextStyle(
                                      color: color.inversePrimary
                                          .withValues(alpha:0.3)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary
                                              .withValues(alpha:0.3))),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: color.secondary)),
                                ),
                                items: programmes
                                    .map((e) => DropdownMenuItem<String>(
                                        value: e, child: Text(e)))
                                    .toList(),
                                onChanged: (value) {
                                  programme = value ?? programme;
                                },
                                hint: Text(programme),
                                onSaved: (value) {
                                  setState(() {
                                    programme = value ?? programme;
                                  });
                                },
                                validator: (value) {
                                  if (programme == "" || programme.isEmpty) {
                                    return "Please select a programme";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Year of passing",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 14),
                              ),
                              const SizedBox(height: 5),
                              DropdownButtonFormField<String>(
                                hint: Text(passingYear),
                                isExpanded: true,
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  prefixIcon:
                                      const Icon(Icons.calendar_month_outlined),
                                  hintText: "Select your passing year",
                                  prefixIconColor:
                                      color.inversePrimary.withValues(alpha:0.3),
                                  labelStyle: TextStyle(
                                      color: color.inversePrimary,
                                      fontSize: 20),
                                  hintStyle: TextStyle(
                                      color: color.inversePrimary
                                          .withValues(alpha:0.3)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary
                                              .withValues(alpha:0.3))),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          BorderSide(color: color.secondary)),
                                ),
                                items: years
                                    .map((year) => DropdownMenuItem<String>(
                                          value: year.toString(),
                                          child: Text(year.toString()),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  passingYear = value ?? passingYear;
                                },
                                onSaved: (value) {
                                  setState(() {
                                    passingYear = value ?? passingYear;
                                  });
                                },
                                validator: (value) {
                                  if (passingYear == "" ||
                                      passingYear.isEmpty) {
                                    return "Please select your year of passing";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              CustomButton(
                                widget: isUploading
                                    ? const CircularProgressIndicator.adaptive()
                                    : null,
                                title: "Update",
                                onTap: isUploading
                                    ? null
                                    : () async {
                                        if (_formKey.currentState?.validate() ??
                                            true) {
                                          setState(() {
                                            isUploading = true;
                                          });
                                          _formKey.currentState?.save();
                                          UserDataService us =
                                              UserDataService();
                                          Map<String, dynamic> userDoc = {
                                            'name': name,
                                            'bio': bio,
                                            'programme': programme,
                                            'passingYear': passingYear,
                                            'isProfileCompleted': true,
                                          };
                                          bool status =
                                              await us.updateUser(userDoc);
                                          if (context.mounted && status) {
                                            Navigator.pushNamed(context,"/home");
                                          } else {
                                            setState(() {
                                              isUploading = false;
                                            });
                                          }
                                        }
                                      },
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: GestureDetector(
                                  onTap: () => Navigator.pushNamed(context,"/showProfile"),
                                  child: RichText(
                                      text: TextSpan(
                                          text: "Don't want to do it now? ",
                                          style: TextStyle(
                                              color: color.inversePrimary
                                                  .withValues(alpha:0.4)),
                                          children: const [
                                        TextSpan(
                                            text: "Get back",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ))
                                      ])),
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                );
              } else {
                return Center(
                    child: CircularProgressIndicator.adaptive(
                  strokeWidth: 4.0, // Adjust thickness if necessary
                  backgroundColor: Colors.transparent,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(color.inversePrimary),
                ));
              }
            },
          ),
        );
}}