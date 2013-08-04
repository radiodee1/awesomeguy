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
		private ArrayList<LevelData> mList = new ArrayList<LevelData>();
		
                public Info interest ;
                public Info head ;
                
                
                public int l_planet = 0;
                
                public LevelList (Info head) {
                    this.head = head;
                    this.showTree(head);
                    
                    for(int i = 0; i < this.l_planet; i ++) {
                        this.showTree(head, i, 1, Tree.TYPE_ABOVE_GROUND, Tree.N_VISIBLE);
                        Info visible  = interest;
                        this.showTree(head, i, 1, Tree.TYPE_ABOVE_GROUND, Tree.N_INVISIBLE);
                        Info invisible = interest;
                        this.add("",i,visible.content, invisible.content);
                        System.out.append("----- level list -----");
                        System.out.println(visible.content);

                    }
                    System.out.println(this.l_planet + " l_planet");
                    
                }
                
                public LevelList () {
                    
                }
                public boolean showTree(Info i, int planet, int maze, int type, String record) {
                    if (record != null && i.name.contentEquals(record) &&
                            planet == i.l_planet && maze == i.l_maze && type == i.l_type) {
                        interest = i;
                        return true;
                    }
                    for(int j = 0; j < i.list.size(); j ++) {
                        showTree(i.list.get(j),planet, maze, type, record);
                        //System.out.println(i.name + " - " +  i.content+ " - "+ i.list.size() + " - " + i.num);
                        //showTree(i.list.get(j));
                    }
                    return false;
                }

                public void showTree(Info i ) {
                    if (i.name.contentEquals(Tree.N_PLANET)) this.l_planet ++;
                    
                    for(int j = 0; j < i.list.size(); j ++) {
                        showTree(i.list.get(j));
                        //System.out.println(i.name + " - " +  i.content+ " - "+ i.list.size() + " - " + i.num);
                        //showTree(i.list.get(j));
                    }
                }

                public void showList(Info i) {
                    for(int j = 0; j < i.list.size(); j ++) {
                        System.out.println("list " +i.name + " - " +  i.content+ " - "+ i.list.size());

                    }
                }
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
	}
	
        class LevelData {
		public String mText = new String("blank");
		public Integer mNum = 1;
                
                public String mLevelTiles = new String();
                public String mObjectTiles = new String();
	}

