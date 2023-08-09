String year(int a) {
  if (a == 0) {
    return "NA";
  } else if (a == 1) {
    return "FY";
  } else if (a == 2) {
    return "SY";
  } else if (a == 2) {
    return "TY";
  } else if (a == 2) {
    return "BE";
  }
  return "NA";
}

int Intyear(String filtyearDDval) {
  if (filtyearDDval == "NA") {
    return 0;
  } else if (filtyearDDval == "FY") {
    return 1;
  } else if (filtyearDDval == "SY") {
    return 2;
  } else if (filtyearDDval == "TY") {
    return 3;
  } else if (filtyearDDval == "BE") {
    return 4;
  } else {
    return 1;
  }
}

