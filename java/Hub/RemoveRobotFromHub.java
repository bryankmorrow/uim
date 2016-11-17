public static void removeRobotFromHub(String hubAddress, String robotName) {
	PDS pds = new PDS();
	NimRequest request = null;
	try {
		pds.putString("name", robotName);
		request = new NimRequest(hubAddress+"/hub", "removerobot", pds);
		request.send();	
	} catch (NimException e) {
		logger.error("Error while removing robot from hub");
	} finally {
		if (request != null) {
			request.disconnect();
			request.close();
		}
	}        
}