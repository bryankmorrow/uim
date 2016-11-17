public static String deployProbe(String primaryHubAddress, String probe) {
	logger.info("### deployProbe("+probe+") invoked");
	NimRequest adeReq = null;
	PDS adePDS = null;
	String job = "";
	try {
		PDS pds = new PDS();
		pds.putString("package", probe);
		pds.putString("robot", primaryHubAddress);
		pds.putString("jobname", primaryHubAddress+"-"+probe);
		adeReq = new NimRequest(primaryHubAddress+"/automated_deployment_engine", "deploy_probe", pds);
		logger.debug("Deploying "+probe+" to robot: "+primaryHubAddress);
		adePDS = adeReq.send();
		job = adePDS.getValueAsString("JobID");
	} catch (NimException e) {
		logger.error("Failed to deploy probe: " + probe + " Message: " + e.getLocalizedMessage());
	} finally {
		if (adeReq != null) {
			adeReq.disconnect();
			adeReq.close();
		}
	}

	return job;
}