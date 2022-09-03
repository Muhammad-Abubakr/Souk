import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app.dart';
import '../../logic/bloc/authentication_bloc.dart';
import '../screens/login_screen.dart';

class ProfilePopUp extends StatelessWidget {
  const ProfilePopUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthenticationBloc>();

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) => state.status == AuthenticationStatus.loggedIn
          ? PopupMenuButton(
              icon: _buildUserAvatar(state.user!.photoURL,
                  color: Theme.of(context).colorScheme.secondary),
              elevation: 2,
              offset: const Offset(0, 10),
              position: PopupMenuPosition.under,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                  topRight: Radius.zero,
                ),
              ),
              itemBuilder: (builderContext) => [
                // ? User Profile
                PopupMenuItem(
                  enabled: false,
                  child: ListTile(
                    enabled: false,
                    leading: _buildUserAvatar(state.user!.photoURL,
                        radius: 24, color: Theme.of(context).primaryColor),
                    title: Text(
                      state.user!.displayName != null && state.user!.displayName!.isNotEmpty
                          ? state.user!.displayName!
                          : state.user!.phoneNumber != null &&
                                  state.user!.phoneNumber!.isNotEmpty
                              ? state.user!.phoneNumber!
                              : state.user!.email != null && state.user!.email!.isNotEmpty
                                  ? state.user!.email!
                                  : 'Username',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.black87,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Row(
                      children: [
                        Icon(
                          size: 18,
                          Icons.verified_user_rounded,
                          color: state.user!.emailVerified ? Colors.teal : Colors.red,
                        ),
                        Text(
                          state.user!.emailVerified ? 'Verified' : 'Not-Verified',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: state.user!.emailVerified ? Colors.teal : Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),

                // Divider
                const PopupMenuItem(
                  enabled: false,
                  height: 0,
                  child: PopupMenuDivider(),
                ),

                // ? Account Preferences
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        Icons.manage_accounts_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Profile settings',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),

                // ? LogOut Button
                PopupMenuItem(
                  onTap: () => SchedulerBinding.instance.addPostFrameCallback(
                    (timeStamp) => showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (builderContext) => AlertDialog(
                              content: const Text("Are you sure you want to log out ?"),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text("CANCEL")),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      SchedulerBinding.instance
                                          .addPostFrameCallback((timeStamp) {
                                        authBloc.add(SignOutEvent());
                                      });
                                    },
                                    child: const Text("YES"))
                              ],
                            )),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        color: Colors.redAccent.shade100,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Log Out',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            )

          // ? User not logged in
          : InkWell(
              onTap: () {
                // pop until we get to App screen
                Navigator.of(context)
                    .popUntil((route) => route.settings.name == App.routeName);

                // Then pop the App screen and push the Login screen
                SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                  Navigator.of(context).popAndPushNamed(LoginScreen.routeName);
                });
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
            ),
    );
  }
}

ClipRRect _buildUserAvatar(String? photoUrl, {double? radius, Color? color}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(128),
    child: Image(
      image: photoUrl != null
          ? Image.network(photoUrl).image
          : Image.asset("lib/assets/icons/baseline_account_circle_black_48dp.png").image,
      fit: BoxFit.cover,
      color: photoUrl == null ? color : null,
      isAntiAlias: true,
      width: radius != null ? radius * 2 : null,
    ),
  );
}
