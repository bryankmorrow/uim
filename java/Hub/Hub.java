
import java.util.ArrayList;
import java.util.List;

public class Hub {
	private List<String> robotList = new ArrayList<String>();
	private List<String> hubList = new ArrayList<String>();
	private String hubName;
	private String hubAddress;
	private boolean isPrimary;
	private String parentHub;

	public Hub(String hubName, String hubAddress) {
		this.hubName = hubName;
		this.hubAddress = hubAddress;
	}

	public List<String> getRobotList() {
		return robotList;
	}

	public void setRobotList(List<String> robotList) {
		this.robotList = robotList;
	}

	public String getHubName() {
		return hubName;
	}

	public void setHubName(String hubName) {
		this.hubName = hubName;
	}

	public String getHubAddress() {
		return hubAddress;
	}

	public void setHubAddress(String hubAddress) {
		this.hubAddress = hubAddress;
	}

	public List<String> getHubList() {
		return hubList;
	}

	public void setHubList(List<String> hubList) {
		this.hubList = hubList;
	}

	public boolean isPrimary() {
		return isPrimary;
	}

	public void setPrimary(boolean isPrimary) {
		this.isPrimary = isPrimary;
	}

	public String getParentHub() {
		return parentHub;
	}

	public void setParentHub(String parentHub) {
		this.parentHub = parentHub;
	}
}
