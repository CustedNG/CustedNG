import 'package:flutter/material.dart';

class FadeIn extends StatefulWidget {  
    final Widget child;  

    FadeIn({@required this.child});  

    @override  _MyFadeInState createState() => _MyFadeInState();
}
class _MyFadeInState extends State<FadeIn> with SingleTickerProviderStateMixin {  
    AnimationController _controller;  
    Animation _animation;  

    @override  void initState() {    
        super.initState();    
        _controller = AnimationController(      
            vsync: this,      
            duration: Duration(milliseconds: 377),    
        );   
         _animation = Tween(      
            begin: 0.0,      
            end: 1.0,    
        ).animate(_controller);  
    }  

    @override  void dispose() {    
        super.dispose();    
        _controller.dispose();    
        super.dispose();  
    } 

    @override  Widget build(BuildContext context) {    
        _controller.forward();    
        return FadeTransition(      
            opacity: _animation,      
            child: widget.child,    
        );  
    }
}