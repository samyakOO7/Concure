import 'package:flutter/material.dart';


class  constant
{
  static Color confirmed  = Colors.black54;
  static Color downbar = Colors.cyan;
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