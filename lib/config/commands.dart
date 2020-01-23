import 'package:custed2/core/tty/command.dart';

import 'package:custed2/cmds/box.dart';
import 'package:custed2/cmds/cbs.dart';
import 'package:custed2/cmds/clear.dart';
import 'package:custed2/cmds/cookies.dart';
import 'package:custed2/cmds/echo.dart';
import 'package:custed2/cmds/help.dart';
import 'package:custed2/cmds/http.dart';
import 'package:custed2/cmds/ls.dart';
import 'package:custed2/cmds/new_year.dart';
import 'package:custed2/cmds/rmrf.dart';
import 'package:custed2/cmds/snake.dart';
import 'package:custed2/cmds/test.dart';
import 'package:custed2/cmds/test2.dart';

final commands = <TTYCommand>[
  BoxCommand(),
  EchoCommand(),
  HelpCommand(),
  SnakeCommand(),
  TestCommand(),
  Test2Command(),
  ClearCommand(),
  CookiesCommand(),
  LsCommand(),
  HttpCommand(),
  NewYearCommand(),
  CbsCommand(),
  RmrfCommand(),
];
