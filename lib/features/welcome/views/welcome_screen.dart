import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart'; // Importe suas cores
import '../../auth/views/login_screen.dart';
import '../../auth/views/register_screen.dart';
import '../view_models/welcome_view_model.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _currentPage = 0;
  final PageController _controller = PageController();
  
  // Instância da ViewModel
  final WelcomeViewModel _viewModel = WelcomeViewModel();

  // Dados estáticos (Imagens e Textos fixos)
  // NOTA: A tag do primeiro slide será substituída pela ViewModel
  final List<Map<String, String>> _staticSlides = [
    {
      "title": "Encontre seu Lugar",
      "text": "Descubra as melhores quadras, academias e parques ao seu redor com apenas um toque.",
      "image": "https://images.unsplash.com/photo-1497656387909-356336b9455f?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", 
      "icon": "location"
    },
    {
      "title": "Treine em Grupo",
      "text": "Junte-se a comunidades locais de corredores, ciclistas e atletas. Nunca treine sozinho.",
      "image": "https://plus.unsplash.com/premium_photo-1745951329361-34bd6ea25778?q=80&w=1333&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", 
      "tag": "+100 Grupos Ativos",
      "icon": "group"
    },
    {
      "title": "Sua Estante de Troféus",
      "text": "Supere seus limites, complete desafios semanais e colecione conquistas reais.",
      "image": "https://plus.unsplash.com/premium_photo-1713628398606-7aeef9b301cd?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "tag": "Conquista Desbloqueada",
      "icon": "trophy"
    },
  ];

  @override
  void initState() {
    super.initState();
    // Escuta mudanças na ViewModel (quando o GPS atualizar)
    _viewModel.addListener(() => setState(() {}));
    // Inicia a busca
    _viewModel.fetchUserLocation();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bolt, color: AppColors.primary, size: 34),
                  SizedBox(width: 8),
                  Text("e-Spire", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -1.0)),
                ],
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _staticSlides.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) => _buildSlide(index),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _staticSlides.length,
                (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  height: 6,
                  width: _currentPage == index ? 32 : 6,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? AppColors.primary : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),

            SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        elevation: 0,
                      ),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen())),
                      child: Text("Começar Agora", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())),
                    child: Text("Já tenho conta", style: TextStyle(color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(int index) {
    final slide = _staticSlides[index];
    String displayTag = (index == 0) ? _viewModel.currentLocationTag : (slide['tag'] ?? "");

    IconData getIcon() {
      if (slide['icon'] == 'location') return Icons.location_on;
      if (slide['icon'] == 'group') return Icons.groups;
      return Icons.emoji_events;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 400,
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: AppColors.primary.withOpacity(0.5), width: 1.5),
              image: DecorationImage(
                image: NetworkImage(slide['image']!),
                fit: BoxFit.cover,
                colorFilter: null, 
              ),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: Offset(0, 10))],
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20, left: 20, right: 20,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), shape: BoxShape.circle),
                        child: Icon(getIcon(), color: AppColors.primary, size: 20),
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          displayTag,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Text(slide['title']!, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, height: 1.2)),
          SizedBox(height: 12),
          Text(slide['text']!, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16, height: 1.5)),
        ],
      ),
    );
  }
}