/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ag20xml;


import java.util.ArrayList;

/**
 *
 * @author dave
 */
	public class LevelList  {
		public ArrayList<LevelData> mList = new ArrayList<LevelData>();
		
                public boolean endReached;
                public Info interest ;
                public Info head ;
                
                
                public int l_planet = 0;
                public int l_maze = 0;
                public int l_challenge = 0;
                public int l_special = 0;
                public int l_text = 0;
                
                public LevelList (Info head) {
                    System.out.println(" --- LevelList ---");
                    
                    this.head = head;
                    this.countPlanets(head);
                    interest = head;
                    for(int i = 0; i < this.l_planet; i ++) {
                        
                        Info visible = new Info(Tree.N_VISIBLE,Tree.C_STRING);
                        Info invisible = new Info(Tree.N_INVISIBLE, Tree.C_STRING);
                        visible.content = new String();
                        invisible.content = new String();
                        
                        this.endReached = false;
                        
                        this.showTree(head, i, 0, Tree.TYPE_ABOVE_GROUND, Tree.N_VISIBLE);
                        
                        visible = interest;
                        
                        this.endReached = false;
                        
                        this.showTree(head, i, 0, Tree.TYPE_ABOVE_GROUND, Tree.N_INVISIBLE); 
                        invisible = interest;
                        
                        if (!visible.content.isEmpty() || !invisible.content.isEmpty() || true) {
                            this.add("",i,visible.content.trim(), invisible.content.trim());
                        }
                        
                        this.endReached = false;
                        this.showTree(head, i, 0, Tree.TYPE_ABOVE_GROUND, Tree.N_CHALLENGES);
                        
                        this.l_challenge = 0;
                        this.countChallenges(head, i, 0, Tree.TYPE_ABOVE_GROUND);
                        if (this.l_challenge > 0) {
                            Info challenge = this.interest;
                            this.listCapture(this.mList.get(i).mChallenge  , 
                                challenge, i, 0, Tree.TYPE_ABOVE_GROUND, Tree.N_CHALLENGES);
                        }
                        
                        this.endReached = false;
                        this.showTree(head, i, 0, Tree.TYPE_ABOVE_GROUND, Tree.N_SPECIAL);
                        
                        this.l_special = 0;
                        this.countSpecial(head, i, 0, Tree.TYPE_ABOVE_GROUND);
                        if (this.l_special > 0) {
                            Info special = this.interest;
                            this.listCapture(this.mList.get(i).mSpecial  , 
                                special, i, 0, Tree.TYPE_ABOVE_GROUND, Tree.N_SPECIAL);
                        }
                        this.endReached = false;
                        this.showTree(head, i, 0, Tree.TYPE_ABOVE_GROUND, Tree.N_TEXT);
                        
                        this.l_text = 0;
                        this.countText(head, i, 0, Tree.TYPE_ABOVE_GROUND);
                        if(this.l_text > 0 ) {
                            Info text = this.interest;
                            this.listCaptureWithNum(this.mList.get(i).mTextMessage  ,this.mList.get(i).mTextNum , 
                                text, i, 0, Tree.TYPE_ABOVE_GROUND, Tree.N_TEXT);
                        }
                        //System.out.println(" numbers " + this.l_challenge + " " + this.l_special + " " + this.l_text);
                        findMazeData( i);
//                        for(int z = 0; z < this.mList.get(i).mMazeData.size(); z ++) {
//                            System.out.println( z + " maze " + this.mList.get(i).mMazeData.get(z).mInvisible);
//                        }
                    }
                    
                    
                }
                
                public LevelList () {
                    
                }
                public Info showTree(Info i, int planet, int maze, int type, String record) {
                    interest = new Info("", Tree.C_NONE);
                    if (record != null && i.name.contentEquals(record) &&
                        planet == i.l_planet && maze == i.l_maze && type == i.l_type) {
                        
                        this.endReached = true;
                        this.interest = i;
                        if (record.contentEquals(Tree.N_INVISIBLE)) System.out.println(i.content);
                        
                        return null;
                    }
                    
                    
                    int j = 0;
                    while ( j < i.list.size() && !this.endReached) {
                        if (!this.endReached ) { 
                            Info test = i.list.get(j);
                            showTree(test, planet, maze, type, record);
                            j++;
                        }
                        else return null;
                    }
                    //endReached = true;
                    return null;
                }

                public void countPlanets(Info i ) {
                    if (i.name.contentEquals(Tree.N_PLANET)) {
                        this.l_planet ++;
                        
                    }
                    
                    for(int j = 0; j < i.list.size(); j ++) {
                        countPlanets(i.list.get(j));
                       
                    }
                }
                public void countMazes(Info i, int index) {
                    if (i.name.contentEquals(Tree.N_MAZE) && i.l_planet == index) {
                        this.l_maze ++;
                    }
                    for(int j = 0; j < i.list.size(); j ++) {
                        countMazes(i.list.get(j), index);
                    }
                }

                public void countChallenges(Info i, int planet, int maze, int type) {
                    if (i.name.contentEquals(Tree.N_CHALLENGES) && i.l_planet == planet && 
                            i.l_maze == maze && i.l_type == type) {
                        this.l_challenge ++;
                    }
                    for(int j = 0; j < i.list.size(); j ++) {
                        countChallenges(i.list.get(j), planet, maze, type);
                    }
                }
                public void countSpecial(Info i, int planet, int maze, int type) {
                    if (i.name.contentEquals(Tree.N_SPECIAL) && i.l_planet == planet && 
                            i.l_maze == maze && i.l_type == type) {
                        this.l_special ++;
                    }
                    for(int j = 0; j < i.list.size(); j ++) {
                        countSpecial(i.list.get(j), planet, maze, type);
                    }
                }
                
                public void countText(Info i, int planet, int maze, int type) {
                    if (i.name.contentEquals(Tree.N_MESSAGE) && i.l_planet == planet && 
                            i.l_maze == maze && i.l_type == type) {
                        this.l_text ++;
                    }
                    for(int j = 0; j < i.list.size(); j ++) {
                        countText(i.list.get(j), planet, maze, type);
                    }
                }
                public void findMazeData( int i) {
                    this.l_maze = 0;
                    countMazes(head, i);
                    int j = this.l_maze;
                    for (int k = 0; k < j; k ++) {
                        MazeData myMaze = new MazeData();
                        myMaze.mVisible = new String();
                        myMaze.mInvisible = new String();
                        
                        this.interest = new Info("", Tree.C_NONE);
                        this.interest.num = 0;
                        
                        this.endReached = false;
                        this.showTree(head, i, k, Tree.TYPE_BELOW_GROUND, Tree.N_MAZE);
                        myMaze.mNum = this.interest.num;
                        
                        this.endReached = false;
                        this.showTree(head, i, k, Tree.TYPE_BELOW_GROUND, Tree.N_HORIZONTAL);
                        myMaze.mHorizontal = new Integer(this.interest.content).intValue();
                        
                        this.endReached = false;
                        this.showTree(head, i, k, Tree.TYPE_BELOW_GROUND, Tree.N_VERTICAL);
                        myMaze.mVertical = new Integer(this.interest.content).intValue();
                        
                        
                        this.interest = new Info("", Tree.C_NONE);
                        this.interest.content = "";
                        
                        this.endReached = false;
                        this.showTree(head, i, k, Tree.TYPE_BELOW_GROUND, Tree.N_VISIBLE);
                        myMaze.mVisible = this.interest.content.trim();
                        
                        this.interest = new Info("", Tree.C_NONE);
                        
                        this.endReached = false;
                        this.showTree(head, i, k, Tree.TYPE_BELOW_GROUND, Tree.N_INVISIBLE);
                        myMaze.mInvisible = this.interest.content.trim();
                        
                        //add array-list-capture here.
                        this.l_challenge = 0;
                        this.countChallenges(head, i, k, Tree.TYPE_BELOW_GROUND);
                        if (this.l_challenge > 0) {
                            this.endReached = false;
                            this.showTree(head, i, k, Tree.TYPE_BELOW_GROUND, Tree.N_CHALLENGES);
                            Info challenge = this.interest;
                            this.listCapture(myMaze.mChallenge, challenge, i, k, Tree.TYPE_BELOW_GROUND, Tree.N_CHALLENGES);
                        }
                        
                        this.l_special = 0;
                        this.countSpecial(head, i, k, Tree.TYPE_BELOW_GROUND);
                        if(this.l_special > 0) {
                            this.endReached = false;
                            this.showTree(head, i, k, Tree.TYPE_BELOW_GROUND, Tree.N_SPECIAL);
                            Info special = this.interest;
                            this.listCapture(myMaze.mSpecial, special, i, k, Tree.TYPE_BELOW_GROUND, Tree.N_SPECIAL);
                        }
                        this.mList.get(i).mMazeData.add(myMaze);
                        System.out.println((k + 1) +" == "+ mList.get(i).mMazeData.size());
                    }
                }
                public void showList(Info i) {
                    for(int j = 0; j < i.list.size(); j ++) {
                        

                    }
                }
                
                public void listCapture(ArrayList<String> list, Info i, int planet, int maze, int type, String record) {
                    this.endReached = false;
                    this.showTree(i, planet, maze, type, record);
                    Info z = this.interest;
                    for (int j = 0; j < z.list.size(); j ++ ) {
                        String text = new String(z.list.get(j).content);
                        list.add(text);
                        System.out.println(text);
                    }
                }
                public void listCaptureWithNum(ArrayList<String> list, ArrayList<Integer> nums, 
                        Info i, int planet, int maze, int type, String record) {
                    this.endReached = false;
                    this.showTree(i, planet, maze, type, record);
                    Info z = this.interest;
                    for (int j = 0; j < z.list.size(); j ++ ) {
                        String text = new String(z.list.get(j).content);
                        int number = z.list.get(j).num;
                        list.add(text);
                        nums.add(number);
                        System.out.println(text + " " + number);
                    }
                }
                
                ////////////////// SIMPLE FUNCTIONS HERE ////////////////
		public void add(String text, Integer i) {
			LevelData temp = new LevelData();
			temp.mNum = i;
			temp.mText = text;
			mList.add(temp);
		}
                public void add(String text, Integer i, String ml, String mO) {
			LevelData temp = new LevelData();
			temp.mNum = i;
			temp.mText = text;
                        temp.mLevelTiles = ml;
                        temp.mObjectTiles = mO;
			mList.add(temp);
		}
                
		public int size() {
			return mList.size();
		}
		
		public ArrayList<String> getStrings() {
			ArrayList<String> temp = new ArrayList<String>();
			for(int i = 0; i < mList.size(); i ++) {
				temp.add(mList.get(i).mText);
			}
			return temp;
		}
		public int getNum(int num) {
			return mList.get(num).mNum;
		}
                
                public void setLabelNumber(int num, int mLabel) {
                    mList.get(num).mNum = mLabel;
                }
                public String getLevelTiles(int num) {
			return mList.get(num).mLevelTiles;
		}
                public String getObjectTiles(int num) {
			return mList.get(num).mObjectTiles;
		}
                
                public void setTiles(int num, String mL, String mO ) {
                        mList.get(num).mLevelTiles = mL;
                        mList.get(num).mObjectTiles = mO;
                }
                public LevelData get(int num) {
                    return mList.get(num);
                }
	}
	
        class LevelData {
		public String mText = new String("blank");
		public Integer mNum = 0;
                
                public String mLevelTiles = new String();
                public String mObjectTiles = new String();
                
                public ArrayList<String> mChallenge = new ArrayList<String>();
                public ArrayList<String> mSpecial = new ArrayList<String>();
                public ArrayList<String> mTextMessage = new ArrayList<String>();
                public ArrayList<Integer> mTextNum = new ArrayList<Integer>();
                public ArrayList<MazeData> mMazeData = new ArrayList<MazeData>();
                
                public AG20jFrameList specialList;
                public AG20jFrameList challengeList;
                public AG20jFrameMaze mazeList;
                public AG20jFrameText textList;
                
                public void addText(String text, int num) {
                    this.mTextMessage.add(text);
                    this.mTextNum.add(num);
                }
	}

        class MazeData {
                public String mText = new String("blank");
		public Integer mNum = 0;
                
                public Integer mHorizontal = 0;
                public Integer mVertical = 0;
                
                public String mVisible = new String();
                public String mInvisible = new String();
                
                public ArrayList<String> mChallenge = new ArrayList<String>();
                public ArrayList<String> mSpecial = new ArrayList<String>();
                
                public AG20jFrameList specialList;
                public AG20jFrameList challengeList;
        }