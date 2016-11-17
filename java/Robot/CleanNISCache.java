public static void cleanNisCache(String robotAddress) {
	PDS cleanPDS = null;
	NimRequest cleanReq = null;
	try {
		cleanReq = new NimRequest(robotAddress+"/controller", "_nis_cache_clean");
		cleanPDS = cleanReq.send();
	} catch (NimException e) {
		logger.error("Failed to send _nis_cache_clean command. Message: " + e.getLocalizedMessage());
	} finally {
		if (cleanReq != null) {
			cleanReq.disconnect();
			cleanReq.close();
		}
	}
	logger.debug(NimUtility.displayPDS(cleanPDS));
	
	PDS restartPDS = null;
	NimRequest restartReq = null;
	try {
		restartReq = new NimRequest(robotAddress+"/controller", "_restart");
		restartPDS = cleanReq.send();
	} catch (NimException e) {
		logger.error("Failed to restart robot. Message: " + e.getLocalizedMessage());
	} finally {
		if (restartReq != null) {
			restartReq.disconnect();
			restartReq.close();
		}
	}
	logger.debug(NimUtility.displayPDS(restartPDS));
}