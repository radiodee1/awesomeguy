package org.davidliebman.android.awesomeguy;

public class BoundingBox {
	private int x;
	private int y;
	private int left, right, top, bottom;
	private int type;
	
	public BoundingBox() {
		x = 0;
		y = 0;
		
		left = 0;
		right = 0;
		top = 0;
		bottom = 0;
		
		type = 0; // space
		
	}
	
	public BoundingBox(int left, int right, int top, int bottom) {
		this.left = left;
		this.right = right;
		this.top = top;
		this.bottom = bottom;
		
		x = 0;
		y = 0;
		type = 0;
		
	}
	
	public static BoundingBox makeSpriteBox(SpriteInfo sprite, int x, int  y) {
		BoundingBox temp = new BoundingBox();
		temp.setLeft ( sprite.getLeftBB() + sprite.getMapPosX() + x);
		temp.setRight ( sprite.getRightBB() + sprite.getMapPosX() + x);
		temp.setTop ( sprite.getTopBB() + sprite.getMapPosY() + y);
		temp.setBottom ( sprite.getBottomBB() + sprite.getMapPosY() + y);
		return temp;
	}
	public static BoundingBox makeBlockBox(int x, int y) {
		  BoundingBox temp = new BoundingBox();
		  temp.setLeft ( x * 8);
		  temp.setRight ( x * 8 + 8);
		  temp.setTop (y * 8);
		  temp.setBottom ( y * 8 + 8);
		  //temp.type = level.objects[y][x];
		  return temp;
	}

	public boolean collisionSimple(BoundingBox other) {
		return collisionSimple(this, other);
	}
	
	public boolean collisionSimple(BoundingBox boxA, BoundingBox boxB) {
		int x[] = new int[4];
		int y[] = new int[4];
		int i, j;
		boolean test = false;
		boolean outsideTest, insideTest;

		x[0] = boxA.left;
		y[0] = boxA.top;

		x[1] = boxA.right;
		y[1] = boxA.top;

		x[2] = boxA.left;
		y[2] = boxA.bottom;

		x[3] = boxA.right;
		y[3] = boxA.bottom;
		for (i = 0; i < 4; i ++) {
			// is one point inside the other bounding box??
			if (x[i] <= boxB.right && x[i] >= boxB.left && y[i] <= boxB.bottom && y[i] >= boxB.top ) {
				// are all other points outside the other bounding box??
				outsideTest = false;

				for (j = 0; j < 4 ; j ++) {
					if (j != i ) {
						if (!(x[j] <= boxB.right && x[j] >= boxB.left && y[j] <= boxB.bottom && y[j] >= boxB.top) ) {
							outsideTest = true;

						}
					}
				}
				if(outsideTest) {
					test = true;

				}
				// is a second point inside the bounding box??
						insideTest = false;
						for (j = 0; j < 4 ; j ++) {
							if (j != i ) {
								if ((x[j] <= boxB.right && x[j] >= boxB.left && y[j] <= boxB.bottom && y[j] >= boxB.top) ) {
									insideTest = true;

								}
							}
						}
						if(insideTest) {
							test = true;

						}

						/////////////////////////
			}
		}
		if (!test) return collisionHelper(boxA, boxB);
		else return true;
	}


	private boolean collisionHelper(BoundingBox boxA, BoundingBox boxB) {
		int x[] = new int [4];
		int y[] = new int [4];
		int i,j;
		boolean test = false;
		boolean outsideTest, insideTest;

		x[0] = boxB.left;
		y[0] = boxB.top;

		x[1] = boxB.right;
		y[1] = boxB.top;

		x[2] = boxB.left;
		y[2] = boxB.bottom;

		x[3] = boxB.right;
		y[3] = boxB.bottom;
		for (i = 0; i < 4; i ++) {
			// is one point inside the other bounding box??
			if (x[i] <= boxA.right && x[i] >= boxA.left && y[i] <= boxA.bottom && y[i] >= boxA.top ) {


				// are all other points outside the other bounding box??
				outsideTest = false;

				for (j = 0; j < 4 ; j ++) {
					if (j != i ) {
						if (!(x[j] <= boxA.right && x[j] >= boxA.left && y[j] <= boxA.bottom && y[j] >= boxA.top) ) {
							outsideTest = true;

						}
					}
				}
				if(outsideTest) {
					test = true;

				}
				// is a second point inside the bounding box??
				insideTest = false;
				for (j = 0; j < 4 ; j ++) {
					if (j != i ) {
						if ((x[j] <= boxA.right && x[j] >= boxA.left && y[j] <= boxA.bottom && y[j] >= boxA.top) ) {
							insideTest = true;

						}
					}
				}
				if(insideTest) {
					test = true;

				}


				//////////////////////////
			}
		}

		return test;
	}

	public static int getCenterBlock(BoundingBox guy) {
		int guyCenter, centerBlock;

		guyCenter = (guy.left + guy.right ) / 2;

		centerBlock = guyCenter / 8;
		if(guyCenter - (centerBlock*8) > 4) centerBlock ++;

		return centerBlock;
	}

	public int getCenterBlock() {
		return getCenterBlock(this);
	}
	
	public int getX() {
		return x;
	}

	public void setX(int x) {
		this.x = x;
	}

	public int getY() {
		return y;
	}

	public void setY(int y) {
		this.y = y;
	}

	public int getLeft() {
		return left;
	}

	public void setLeft(int left) {
		this.left = left;
	}

	public int getRight() {
		return right;
	}

	public void setRight(int right) {
		this.right = right;
	}

	public int getTop() {
		return top;
	}

	public void setTop(int top) {
		this.top = top;
	}

	public int getBottom() {
		return bottom;
	}

	public void setBottom(int bottom) {
		this.bottom = bottom;
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}
	
	
	
	
}
