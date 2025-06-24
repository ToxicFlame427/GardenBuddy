import 'package:flutter/material.dart';
import 'package:garden_buddy/gbio.dart';
import 'package:garden_buddy/screens/home_screen.dart';

class IntroductionRoot extends StatefulWidget {
  const IntroductionRoot({super.key});

  @override
  State<StatefulWidget> createState() {
    return _IntroductionRootState();
  }
}

class _IntroductionRootState extends State<IntroductionRoot> {
  int _currentWidget = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> introWidgets = [
      // First page
      Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to Garden Buddy!",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "assets/icons/icon.jpg",
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            Text(
              "This application was made to make access to gardening information and tools easier!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            )
          ]),
      // Second Page
      Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Theme.of(context).colorScheme.scrim,
                  width: 2,
                )),
                child: Image.asset(
                  "assets/images/intro/database.png",
                  height: 300,
                  width: 300,
                ),
              ),
            ),
            Text(
              "Simple UI",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              "The UI was made to be simple and as easy to use as possible, making for a great gardening companion with little complexity.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            )
          ]),
      // Third page
      Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Complete features",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              "Garden Buddy features many tools that make gardening easier! Assess plant health, identify plants by image, or search our database of plants featuring both plant species and varieties. Access to some of these tools may be limited.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Theme.of(context).colorScheme.scrim,
                  width: 2,
                )),
                child: Image.asset(
                  "assets/images/intro/viewer.png",
                  height: 300,
                  width: 300,
                ),
              ),
            ),
          ]),
      // Fourth page
      Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Partially powered by AI",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Theme.of(context).colorScheme.scrim,
                  width: 2,
                )),
                child: Image.asset(
                  "assets/images/intro/ai_ex.gif",
                  height: 300,
                  width: 300,
                ),
              ),
            ),
            Text(
              "This is an app that is made partially with artificial intelligence. Scan plants to assess their health, identify plants by image, or directly chat with our gardening guru, Garden AI! All powered by the latest model of Google Gemini.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            )
          ]),
      // Fifth page
      Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Notice",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              "Garden Buddy is always being updated to bring new cool features to help nurture your garden to the fullest. Keep the app up-to-date for new useful features that are planned to soon arrive!\n\nPress the check button to start using Garden Buddy!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            )
          ]),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // MARK: Moving buttons - These can simply be ignored
            Expanded(
              child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  // So apparently, when using AnimtedSwitcher, the child needs to have a key to differentiate it.
                  // Key can be anything (preferably an integer), but it needs to change to animate
                  child: Container(
                    key: ValueKey(_currentWidget),
                    child: introWidgets[_currentWidget],
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                // Only show the arrow when it can be clicked to prevent out-of-bounds issues
                if (_currentWidget > 0)
                  IconButton(
                      iconSize: 40,
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        setState(() {
                          _currentWidget--;
                        });
                      },
                      icon: Icon(Icons.arrow_back_ios))
                else
                  SizedBox(
                    width: 56,
                  ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: CircleAvatar(
                        radius: 6,
                        backgroundColor: _currentWidget == 0
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).cardColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: CircleAvatar(
                        radius: 6,
                        backgroundColor: _currentWidget == 1
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).cardColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: CircleAvatar(
                        radius: 6,
                        backgroundColor: _currentWidget == 2
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).cardColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: CircleAvatar(
                        radius: 6,
                        backgroundColor: _currentWidget == 3
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).cardColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: CircleAvatar(
                        radius: 6,
                        backgroundColor: _currentWidget == 4
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).cardColor,
                      ),
                    )
                  ],
                ),

                if (_currentWidget < 4)
                  IconButton(
                      iconSize: 40,
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        setState(() {
                          _currentWidget++;
                        });
                      },
                      icon: Icon(Icons.arrow_forward_ios))
                else
                  IconButton(
                      iconSize: 40,
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        // Save that the intro was finished with shared preferences, so it can be skipped on next app launch
                        GBIO.setIntroComplete();
                        // Move to the home screen after introduction
                        Navigator.pop(context);
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (ctx) => HomeScreen()));
                      },
                      icon: Icon(Icons.check))
              ],
            ),
            SizedBox(
              height: 25,
            )
          ],
        ),
      ),
    );
  }
}
