
import java.util.ArrayList;
import java.util.List;

public class Robot {
	private List<String> probeList = new ArrayList<String>();
	private List<String> packageList = new ArrayList<String>();
	private String robotName;
	private String robotAddress;
	private String hubAddress;
	private String hubName;
	private String origin;
	private boolean isActive;

	public Robot(String origin, String robotName, String robotAddress, String hubAddress, boolean isActive) {
		this.robotName = robotName;
		this.robotAddress = robotAddress;
		this.hubAddress = hubAddress;
		this.origin = origin;
		// hub name is derived from hub address
		String[] address = hubAddress.split("/");
		hubName = address[2];
		this.isActive = isActive;
	}

	public String getRobotName() {
		return robotName;
	}

	public String getRobotAddress() {
		return robotAddress;
	}

	public String getHubAddress() {
		return hubAddress;
	}

	public String getHubName() {
		return hubName;
	}
	
	public String getOrigin() {
		return origin;
	}
	
	public List<String> getPackageList() {
		return packageList;
	}

	public void setPackageList(List<String> packages) {
		this.packageList = packages;
	}
	
	public List<String> getProbeList() {
		return probeList;
	}

	public void setProbeList(List<String> probes){
		this.probeList=probes;
	}

	public boolean isActive() {
		return isActive;
	}

	public void setActive(boolean isActive) {
		this.isActive = isActive;
	}
}
