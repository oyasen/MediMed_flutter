import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../Widgets/custom_paymentoption.dart';

class PaymentPage2 extends StatefulWidget {
  final price;
  final nurse;
  const PaymentPage2({super.key, required this.price, this.nurse});

  @override
  State<PaymentPage2> createState() => _PaymentPage2State();
}

class _PaymentPage2State extends State<PaymentPage2>
    with TickerProviderStateMixin {
  int selectedPaymentIndex = -1;
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final List<PaymentMethodData> paymentMethods = [
    PaymentMethodData(
      icon: FontAwesomeIcons.creditCard,
      title: 'Add New Card',
      subtitle: 'Visa, Mastercard, American Express',
      color: const Color(0xff4CAF50),
      gradient: [const Color(0xff4CAF50), const Color(0xff45a049)],
    ),
    PaymentMethodData(
      icon: Icons.payment,
      title: 'Insta Pay',
      subtitle: 'Quick and secure payment',
      color: const Color(0xffFF6B35),
      gradient: [const Color(0xffFF6B35), const Color(0xffF7931E)],
    ),
    PaymentMethodData(
      icon: Icons.attach_money,
      title: 'Vodafone Cash',
      subtitle: 'Mobile wallet payment',
      color: const Color(0xffE91E63),
      gradient: [const Color(0xffE91E63), const Color(0xffAD1457)],
    ),
    PaymentMethodData(
      icon: FontAwesomeIcons.paypal,
      title: 'PayPal',
      subtitle: 'Pay with your PayPal account',
      color: const Color(0xff0070BA),
      gradient: [const Color(0xff0070BA), const Color(0xff003087)],
    ),
    PaymentMethodData(
      icon: FontAwesomeIcons.applePay,
      title: 'Apple Pay',
      subtitle: 'Touch ID or Face ID',
      color: const Color(0xff000000),
      gradient: [const Color(0xff434343), const Color(0xff000000)],
    ),
    PaymentMethodData(
      icon: FontAwesomeIcons.googlePay,
      title: 'Google Pay',
      subtitle: 'Pay with Google',
      color: const Color(0xff4285F4),
      gradient: [const Color(0xff4285F4), const Color(0xff1a73e8)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _slideController.forward();
    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff0299c6),
              Color(0xff0277a3),
              Color(0xff025c7a),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Payment Methods',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.security,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              // Price Display
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Amount to Pay',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${widget.price ?? "0.00"}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Main Content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          // Handle Bar
                          Container(
                            margin: const EdgeInsets.only(top: 12),
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Payment Methods List
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Popular Methods Section
                                  const Text(
                                    '💳 Popular Methods',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Build payment method cards
                                  ...paymentMethods.take(3).map((method) {
                                    int index = paymentMethods.indexOf(method);
                                    return _buildPaymentMethodCard(method, index);
                                  }).toList(),

                                  const SizedBox(height: 30),

                                  // More Options Section
                                  const Text(
                                    '🌟 More Options',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  ...paymentMethods.skip(3).map((method) {
                                    int index = paymentMethods.indexOf(method);
                                    return _buildPaymentMethodCard(method, index);
                                  }).toList(),

                                  const SizedBox(height: 30),

                                  // Security Notice
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xff0299c6).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xff0299c6).withOpacity(0.2),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.shield_outlined,
                                          color: const Color(0xff0299c6),
                                          size: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        const Expanded(
                                          child: Text(
                                            'Your payment information is secured with bank-level encryption',
                                            style: TextStyle(
                                              color: Color(0xff0299c6),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 100), // Space for floating button
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Floating Continue Button
      floatingActionButton: selectedPaymentIndex != -1
          ? Container(
        width: MediaQuery.of(context).size.width - 40,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xff0299c6), Color(0xff0277a3)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff0299c6).withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            // Handle payment method selection
            _handlePaymentMethodSelected();
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          label: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Continue with ${paymentMethods[selectedPaymentIndex].title}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildPaymentMethodCard(PaymentMethodData method, int index) {
    bool isSelected = selectedPaymentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentIndex = index;
        });

        // Add haptic feedback
        // HapticFeedback.lightImpact();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: method.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Colors.grey.withOpacity(0.2),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? method.color.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
              spreadRadius: isSelected ? 2 : 1,
              blurRadius: isSelected ? 15 : 5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.2)
                      : method.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  method.icon,
                  size: 24,
                  color: isSelected ? Colors.white : method.color,
                ),
              ),

              const SizedBox(width: 16),

              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      method.subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected
                            ? Colors.white.withOpacity(0.8)
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Selection Indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.white : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.grey,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Icon(
                  Icons.check,
                  size: 16,
                  color: method.color,
                )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePaymentMethodSelected() {
    // Handle the selected payment method
    // You can navigate to the next page or process the payment
    print('Selected payment method: ${paymentMethods[selectedPaymentIndex].title}');

    // Example: Navigate to payment processing page
    // Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentProcessingPage()));
  }
}

class PaymentMethodData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final List<Color> gradient;

  PaymentMethodData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.gradient,
  });
}