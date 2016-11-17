public static String getJobStatus (String primaryHubAddress, String job) {
	Boolean isComplete = false;
	String result = "";
	while (!isComplete) {
		PDS adePDS = null;
		NimRequest adeReq = null;
		try {
			PDS pds = new PDS();
			pds.putString("JobID", job);
			adeReq = new NimRequest(primaryHubAddress+"/automated_deployment_engine", "get_status", pds);
			adePDS = adeReq.send();
		} catch (NimException e) {
			logger.error("Failed to get job status on job: " + job + " Message: " + e.getLocalizedMessage());
		} finally {
			if (adeReq != null) {
				adeReq.disconnect();
				adeReq.close();
			}
		}
		String status = adePDS.getValueAsString("JobStatus");
		logger.debug("Status for job "+job+" is: "+ status);
		if ( status.contains("Queued") || status.contains("In_Progress") ) {
			result = status;
		} else if (status.contains("Failed") || status.contains("Incomplete")) {
			result = status;
		}
		else {
			result = status;
			isComplete = true;
		}           
	}
	return result;
}