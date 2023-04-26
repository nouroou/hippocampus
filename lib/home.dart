import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hippocampus/models/user.dart';
import 'package:hippocampus/pages/notes_page.dart';
import 'package:hippocampus/pages/search_page.dart';
import 'package:hippocampus/pages/tasks_page.dart';
import 'package:hippocampus/providers/user_provider.dart';

import 'package:hippocampus/resources/firebase_methods.dart';
import 'package:hippocampus/resources/auth_methods.dart';
import 'package:hippocampus/utils/constants.dart';
import 'package:hippocampus/widgets/cached_image.dart';
import 'package:hippocampus/widgets/custom_dialog.dart';
import 'package:hippocampus/widgets/user_circle.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  late PageController pageController;
  late UserProvider userProvider;
  FirebaseMethods _firebaseMethods = FirebaseMethods();
  AuthMethods _authMethods = AuthMethods();
  int page = 0;

  bool googleEnteringUsername = false, entringUserDetails = false;

  late String username;
  late String name;
  late String googleUsername;
  late String email;

  bool desktopLayout = false;

  @override
  void initState() {
    super.initState();
    _authMethods.getCurrentUser().then((value) {
      _authMethods.userExists(value!).then((isUserNew) {
        if (isUserNew) {
          return showModalBottomSheet(
              context: context,
              builder: (context) {
                return usernameSheet(value);
              });
        }
      });
    });

    pageController = PageController(initialPage: page);
  }

  googlUsernameEnterButton(auth.User user) async {
    if (!googleEnteringUsername) {
      return ElevatedButton(
        onPressed: () {
          setState(() {
            googleEnteringUsername = true;
          });
          _firebaseMethods.addDataToDb(user, googleUsername).then((result) {
            if (result != null && result is! String) {
              setState(() {
                googleEnteringUsername = false;
              });
            } else {
              setState(() {
                googleEnteringUsername = false;
              });
              return showDialog(
                  context: context,
                  builder: (context) {
                    return CustomDialog(
                      title: 'Error..',
                      content: Text(result.toString(),
                          style: Theme.of(context).textTheme.bodyText2),
                      mainActionText: 'Try Again',
                      function: () {
                        //TODO: delete account and try sign up again
                      },
                      secondaryActionText: '',
                      function1: () {},
                    );
                  });
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          child: Text('Enter', style: Theme.of(context).textTheme.bodyText2),
        ),
      );
    } else {
      return ElevatedButton.icon(
        onPressed: () {},
        icon: CircularProgressIndicator(
            backgroundColor: Theme.of(context).primaryColor, strokeWidth: 1),
        label: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 32),
            child: Text('Finishing up..',
                style: Theme.of(context).textTheme.bodyText2),
          ),
        ),
      );
    }
  }

  Widget usernameSheet(auth.User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 20),
          Text(
            'Provid Your Username',
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          TextFormField(
            decoration: InputDecoration(
                isDense: true,
                hintText: 'Enter your username',
                prefixIcon: Icon(
                  Feather.user,
                  color: Theme.of(context).primaryIconTheme.color,
                )),
            validator: (input) {
              return input!.toLowerCase().trim().isEmpty
                  ? 'Enter a valid username'
                  : input = input;
            },
            onChanged: (value) {
              googleUsername = value;
            },
          ),
          const SizedBox(height: 20),
          googlUsernameEnterButton(user),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    final User homeUserProvider = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight * 1.5),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 20),
                child: Text('Mooncurse',
                    style: Theme.of(context).textTheme.headline5),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap: () {},
                  onLongPress: () => accountSheet(homeUserProvider),
                  child: UserCircle(
                      width: 40,
                      height: 40,
                      child: CachedImage(
                        homeUserProvider.profileUrl,
                        height: 40,
                        width: 40,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        onTap: (index) {
          setState(() {
            page = index;
            pageController.jumpToPage(page);
          });
        },
        currentIndex: page,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Feather.message_circle,
            ),
            activeIcon: Icon(
              Feather.message_circle,
            ),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Feather.video,
              ),
              activeIcon: Icon(
                Feather.video,
              ),
              label: 'Calls'),
        ],
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (MediaQuery.of(context).size.width > 600) {
          desktopLayout = true;
        } else {
          desktopLayout = false;
        }
        if (desktopLayout) {
          return Row(
            children: [
              NavigationRail(
                destinations: [
                  const NavigationRailDestination(
                      icon: Icon(
                        Feather.paperclip,
                      ),
                      selectedIcon: Icon(
                        Feather.paperclip,
                      ),
                      label: Text('')),
                  const NavigationRailDestination(
                    icon: Icon(
                      Feather.check_square,
                    ),
                    selectedIcon: Icon(
                      Feather.check_square,
                    ),
                    label: Text(''),
                  ),
                ],
                onDestinationSelected: (int index) {
                  setState(() {
                    page = index;
                    pageController.jumpToPage(page);
                  });
                },
                selectedIndex: page,
              ),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(
                  child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: NotesPage(),
              )),
              Expanded(
                  child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TasksPage(),
              )),
            ],
          );
        } else {
          return Column(
            children: [
              searchBox(homeUserProvider),
              Expanded(
                child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    onPageChanged: (int index) {
                      setState(() {
                        page = index;
                        pageController.jumpToPage(page);
                      });
                    },
                    controller: pageController,
                    children: []),
              ),
            ],
          );
        }
      }),
    );
  }

  accountSheet(User userProvider) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    label: Text(
                      'Add Account',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    icon: Icon(
                      Feather.plus,
                      color: Theme.of(context).primaryIconTheme.color,
                    ),
                  ),
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: userProvider.id == userProvider.id
                                ? Theme.of(context).accentColor
                                : Colors.transparent,
                            width: 1)),
                    child: CircleAvatar(
                        radius: 24,
                        backgroundImage: userProvider.profileUrl.isNotEmpty
                            ? CachedNetworkImageProvider(
                                userProvider.profileUrl)
                            : const CachedNetworkImageProvider(
                                imageNotAvailable)),
                  ),
                  title: Text(userProvider.username,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .apply(fontSizeFactor: 1.3)),
                  subtitle: Text(userProvider.name,
                      style: Theme.of(context).textTheme.bodyText1),
                ),
              ],
            ),
          );
        });
  }

  Widget searchBox(User userProvider) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => SearchPage(userProvider: userProvider))),
        child: TextFormField(
          style: Theme.of(context).textTheme.bodyText1,
          textInputAction: TextInputAction.search,
          autofocus: false,
          enabled: false,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            hintText: 'Search..',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            isDense: true,
            prefixIcon: Icon(Feather.search,
                color: Theme.of(context).primaryIconTheme.color),
          ),
        ),
      ),
    );
  }
}
