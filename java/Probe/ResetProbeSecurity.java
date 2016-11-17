public static String resetProbeSecurity(String robotAddress, String probe) {
	NimRequest vRequest = null;
	NimRequest dRequest = null;
	NimRequest rRequest = null;

	try {
		logger.info("Starting probe_verify attempt");
		PDS pds = new PDS();
		pds.putString("name", probe);
		vRequest = new NimRequest(robotAddress+"/controller", "probe_verify", pds);
		vRequest.send();
	} catch (NimException e) {
		logger.error("Failed to verify probe: "+probe+" on "+robotAddress);
		return "failed";
	} finally {
		if (vRequest != null) {
			vRequest.disconnect();
			vRequest.close();
		}
	}
	
	try {
		logger.info("Starting probe_deactivate attempt");
		PDS pds = new PDS();
		pds.putString("name", probe);
		pds.putInt("waitforstop", 1);
		dRequest = new NimRequest(robotAddress+"/controller", "probe_deactivate", pds);
		dRequest.send();
	} catch (NimException e) {
		logger.error("Failed to deactivate probe: "+probe+" on "+robotAddress);
		return "Failed to deactivate probe: "+probe+" on "+robotAddress;
	} finally {
		if (dRequest != null) {
			dRequest.disconnect();
			dRequest.close();
		}
	}
	
	try {
		logger.info("Starting probe_activate attempt");
		PDS pds = new PDS();
		pds.putString("name", probe);
		rRequest = new NimRequest(robotAddress+"/controller", "probe_activate", pds);
		rRequest.send();
	} catch (NimException e) {
		logger.error("Failed to activate probe: "+probe+" on "+robotAddress);
		return "Failed to activate probe: "+probe+" on "+robotAddress;
	} finally {
		if (rRequest != null) {
			rRequest.disconnect();
			rRequest.close();
		}
	}
	return "Successfully reset security on probe: "+probe+" at "+robotAddress;
}