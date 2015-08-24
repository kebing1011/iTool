//
//  install.c
//  iTools
//
//  Created by mao on 8/23/15.
//  Copyright (c) 2015 Maokebing. All rights reserved.
//

#include "install.h"
#include <CoreFoundation/CoreFoundation.h>
#include "SDMMobileDevice.h"
#include "Core.h"
#include "dev.h"

void InstallAppOnFirstDevice(char *app_path)
{
	CFArrayRef devices = SDMMD_AMDCreateDeviceList();
	CFIndex numberOfDevices = CFArrayGetCount(devices);
	if (numberOfDevices) {
		sdmmd_return_t result;
		SDMMD_AMDeviceRef device = (SDMMD_AMDeviceRef)CFArrayGetValueAtIndex(devices, 0);
		bool validDevice = SDMMD_AMDeviceIsValid(device);
		if (validDevice) {
			// attempting to connect to the device
			result = SDMMD_AMDeviceConnect(device);
			if (SDM_MD_CallSuccessful(result)) {
				CFTypeRef deviceName = SDMMD_AMDeviceCopyValue(device, NULL, CFSTR(kDeviceName));
				result = SDMMD_AMDeviceStartSession(device);
				
				CFTypeRef deviceUDID = SDMMD_AMDeviceCopyUDID(device);
				if (!deviceUDID) {
					deviceUDID = SDMMD_AMDeviceCopyValue(device, NULL, CFSTR(kUniqueDeviceID));
				}
				char *udid_cstr = SDMCFStringGetString(deviceUDID);
				char *name_cstr = SDMCFStringGetString(deviceName);

				printf("install app to %s\n",name_cstr);

				
				CFSafeRelease(deviceName);
				CFSafeRelease(deviceUDID);
				
				SDMMD_AMDeviceStopSession(device);
				SDMMD_AMDeviceDisconnect(device);
				
				//install app now!
				TranferAppForInstallOnDevice(udid_cstr, app_path);
				InstallApplicationOnDevice(udid_cstr, app_path);
				
				Safe(free, udid_cstr);
				Safe(free, name_cstr);
			}
		}
	}
	CFSafeRelease(devices);
}

