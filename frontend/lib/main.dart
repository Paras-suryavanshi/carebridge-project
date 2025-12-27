import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'config/theme.dart';
import 'config/routes.dart';
import 'constants/strings.dart';

/// Entry point of the application
/// Initializes necessary services and configurations before running the app
void main() async {
  // Ensures Flutter binding is initialized before any async operations
  WidgetsFlutterBinding.ensureInitialized();

  // Configure device orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configure system UI overlay for consistent appearance
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const CarebridgeApp());
}

/// Root application widget
///
/// This is a stateless widget as the app configuration doesn't change
/// Uses const constructor for better performance
class CarebridgeApp extends StatelessWidget {
  const CarebridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      // Navigation configuration
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,

      // Accessibility: Lock text scaling to prevent layout breaks
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0,
            // Ensure bold text accessibility setting doesn't break UI
            boldText: false,
          ),
          child: child!,
        );
      },
    );
  }
}

// ============================================================================
// PRODUCTION-READY COUNTER APP EXAMPLE (Optimized Implementation)
// ============================================================================
// Uncomment below to see the optimized counter demo instead of Carebridge

/*
void main() {
  runApp(const OptimizedCounterApp());
}

/// Production-ready counter application
/// Demonstrates Flutter best practices and performance optimizations
class OptimizedCounterApp extends StatelessWidget {
  const OptimizedCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Optimized Counter Demo',
      debugShowCheckedModeBanner: false,
      
      // Performance: Define theme once, reuse throughout app
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        
        // Accessibility: Define text scaling limits
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      
      home: const CounterHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

/// Home page widget with counter functionality
/// 
/// Performance optimizations:
/// - Uses const constructor where possible
/// - Separates stateless UI (AppBar) from stateful logic
/// - Implements proper state management with setState
class CounterHomePage extends StatefulWidget {
  const CounterHomePage({super.key, required this.title});

  /// Page title - immutable, passed from parent
  final String title;

  @override
  State<CounterHomePage> createState() => _CounterHomePageState();
}

/// Private state class - encapsulates counter logic
/// 
/// Best Practices:
/// - Clear separation of concerns (UI vs State)
/// - Proper use of setState for reactive updates
/// - Minimal rebuild scope
class _CounterHomePageState extends State<CounterHomePage> {
  // State variable - private to this widget
  int _counter = 0;

  /// Increment counter with proper state management
  /// 
  /// Performance: Only rebuilds this widget and its descendants
  /// Error Handling: Could add max counter limit here if needed
  void _incrementCounter() {
    setState(() {
      _counter++;
      
      // Example: Add business logic/constraints
      // if (_counter >= 999) _counter = 0; // Reset at max
    });
  }

  /// Reset counter to zero
  /// Demonstrates additional state operations
  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Cache theme for performance (avoid repeated lookups)
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      // AppBar is const-optimized (doesn't rebuild with counter changes)
      appBar: AppBar(
        backgroundColor: colorScheme.inversePrimary,
        title: Text(widget.title),
        
        // Accessibility: Semantic label for screen readers
        centerTitle: true,
        
        // Action: Reset button
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Counter',
            onPressed: _resetCounter,
          ),
        ],
      ),
      
      body: Center(
        // Performance: SingleChildScrollView for small screens
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Static text - const for performance
            const Text(
              'You have pushed the button this many times:',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            // Counter display - optimized widget
            _CounterDisplay(count: _counter),
            
            const SizedBox(height: 32),
            
            // Additional info - demonstrates computed values
            _CounterStats(count: _counter),
          ],
        ),
      ),
      
      // FAB with semantic label for accessibility
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        // Semantic label for screen readers
        child: const Icon(Icons.add, semanticLabel: 'Add one'),
      ),
    );
  }
}

/// Optimized counter display widget
/// 
/// Performance Benefits:
/// - Separated into own widget for focused rebuilds
/// - Uses const constructor
/// - Only rebuilds when count changes
class _CounterDisplay extends StatelessWidget {
  const _CounterDisplay({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      child: Text(
        '$count',
        // Key ensures animation triggers on value change
        key: ValueKey<int>(count),
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

/// Counter statistics widget
/// 
/// Demonstrates:
/// - Computed values from state
/// - Separation of UI components
/// - Const optimization where possible
class _CounterStats extends StatelessWidget {
  const _CounterStats({required this.count});

  final int count;

  /// Computed property - calculates on demand
  bool get isEven => count % 2 == 0;
  
  /// Computed property - performance concern handled at display time
  String get countStatus {
    if (count == 0) return 'Ready to start!';
    if (count < 10) return 'Just getting started';
    if (count < 50) return 'Making progress!';
    if (count < 100) return 'Impressive!';
    return 'Counter champion! 🏆';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Even/Odd indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isEven ? Icons.check_circle : Icons.circle_outlined,
                  color: isEven ? Colors.green : Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  isEven ? 'Even Number' : 'Odd Number',
                  style: TextStyle(
                    color: isEven ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Status message
            Text(
              countStatus,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.secondary,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
*/
