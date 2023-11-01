class Coordinate{
  double x;
  double y;
  
  public Coordinate(double x, double y){
    this.x = x;
    this.y = y;
  }
  
  double getX(){
    return x;
  }
  
  double getY(){
    return y;
  }
  
  @Override
  public int hashCode(){
    return 31*31*Double.valueOf(x).hashCode()
          +   31*Double.valueOf(y).hashCode();
  }
  
  @Override
  public boolean equals(Object other){
    if (other == null || !(other instanceof Coordinate)) {
        return false;
    }
    Coordinate n = (Coordinate)other;
    return x == n.x && y == n.y;
  }
}
