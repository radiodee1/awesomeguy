package org.davidliebman.android.awesomeguy;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.view.Window;
import android.widget.ImageView;
import android.graphics.*;

public class TileCutter {
	
	private int mTilesHeight = 128;
	private int mTilesWidth = 224;
	private int mBlockHeight = 8;
	private int mBlockWidth = 8;
	private int mNumTiles = 0;
	private int mWidthInTiles = mTilesWidth/ mBlockWidth;
	private int mHeightInTiles = mTilesHeight/ mBlockHeight;
	
	private Matrix mMatrix = new Matrix();
	private Bitmap mTileMap;
	
	private int mTileAdjustment = 3;
	
	public TileCutter() {
		getNumTiles();
		updateDimensionsInTiles();
		mMatrix.postScale(2, 2);
	}
	
	
	public TileCutter (Bitmap tiles, int width, int height) {
		mTileMap = tiles;
		
		mWidthInTiles = width;
		mHeightInTiles = height;
		mMatrix.postScale(2, 2);

	}
	
	public TileCutter (Bitmap tiles) {
		mTileMap = tiles;
		mMatrix.postScale(2, 2);

	}
	
	public TileCutter (int tilesHeight, int tileWidth, int blockHeight, int blockWidth) {
		mTilesHeight = tilesHeight;
		mTilesWidth = tileWidth;
		mBlockHeight = blockHeight;
		mBlockWidth = blockWidth;
		getNumTiles();
		updateDimensionsInTiles();
		mMatrix.postScale(2, 2);

	}
	
	/* tiles and tile sizes */
	public void setTilesHeightWidth(int tilesHeight, int tilesWidth) {
		mTilesHeight = tilesHeight;
		mTilesWidth = tilesWidth;
	}
	public void setTilesHeight(int tilesHeight) {
		mTilesHeight = tilesHeight;
	}
	public void setTilesWidth (int tilesWidth) {
		mTilesWidth = tilesWidth;
	}
	public int getTilesHeight() {
		return mTilesHeight;
	}
	public int getTilesWidth() {
		return mTilesHeight;
	}
	public void setBlockHeightWidth(int blockHeight, int blockWidth) {
		mBlockHeight = blockHeight;
		mBlockWidth = blockWidth;
	}
	public void setBlockHeight(int height) {
		mBlockHeight = height;
	}
	public void setBlockWidth(int width) {
		mBlockWidth = width;
	}
	public int getBlockHeight() {
		return mBlockHeight;
	}
	public int getBlockWidth() {
		return mBlockWidth;
	}
	public int getNumTiles() {
		mNumTiles = (mTilesHeight / mBlockHeight) * (mTilesWidth / mBlockWidth);
		return mNumTiles;
	}
	public void updateDimensionsInTiles() {
		mWidthInTiles = mTilesWidth/ mBlockWidth;
		mHeightInTiles = mTilesHeight/ mBlockHeight;
	}
	
	public int getWidthInTiles() {
		return mWidthInTiles;
	}
	public int getHeightInTiles() {
		return mHeightInTiles;
	}
	
	public void setTileMap(Bitmap map) {
		this.mTileMap = map;
	}
	
	public Bitmap getTile(int i) {
		i = i + mTileAdjustment;
		int row = i / mWidthInTiles;
		int col = i - (mWidthInTiles * row) ;
		
		Bitmap temp = getTile(row, col);
		return temp;
		
	}
	public Bitmap getTile(int row, int col) {
		int height = this.mBlockHeight;
		int width = this.mBlockWidth;
		Bitmap temp = Bitmap.createBitmap(mTileMap, col * width,row * height, width , height ,mMatrix,false);
		return temp;
	}
	
	
	
}
