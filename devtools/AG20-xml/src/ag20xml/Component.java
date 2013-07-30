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
public class Component {
    
    public String name = new String();
    public String contents = new String();
    public ArrayList<Component> list = new ArrayList<Component>();
    public boolean hasChildren = false;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getContents() {
        return contents;
    }

    public void setContents(String contents) {
        this.contents = contents;
    }

    public boolean isHasChildren() {
        return hasChildren;
    }

    public void setHasChildren(boolean hasChildren) {
        this.hasChildren = hasChildren;
    }
    public void addComponent(Component c) {
        this.list.add(c);
    }
    public void clearList() {
        this.list.clear();
    }
}
