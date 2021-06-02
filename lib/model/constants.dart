import 'package:flutter/material.dart';


class  constant
{
  static Color confirmed  = Colors.black;
  static Color downbar = Color(0xff202c3b);
  static Color tapInfo = Colors.blue;

  static Color navbar = Colors.white;
  // static Color active , recov, deat;
  setcolor (Color change,Color down)
  {
    confirmed = change;
    downbar = down;
  }
  getcolor()
  {
    return confirmed;
  }



}