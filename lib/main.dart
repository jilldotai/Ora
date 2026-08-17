import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/avatar_studio/ui/avatar_studio_screen.dart';
import 'features/auth/ui/offline_signup_screen.dart';
import 'features/avatar_studio/service/identity_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final identityService = IdentityService();
  final activeAvatar = await identityService.getActiveAvatarId();
  
  runApp(IOkTApp(startScreen: activeAvatar == null 
      ? const OfflineSignupScreen() 
      : const AvatarStudioScreen()));
}

class IOkTApp extends StatelessWidget {
  final Widget startScreen;
  
  const IOkTApp({super.key, required this.startScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IOkT - Avatar Studio',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: startScreen,
    );
  }
}
