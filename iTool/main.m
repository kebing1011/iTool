//
//  main.m
//  iTool
//
//  Created by Mao on 8/24/15.
//  Copyright (c) 2015 Mao. All rights reserved.
//


#include <getopt.h>
#include <CoreFoundation/CoreFoundation.h>
#include "SDMMobileDevice.h"
#include "attach.h"
#include "list.h"
#include "dev.h"
#include "install.h"
#include "Attributes.h"


ATR_UNUSED static char *helpArg = "-h,--help";
static char *listArg = "-l,--list";
static char *deviceArg = "-d,--device";
static char *appArg = "-a,--app";

enum iOSConsoleOptions {
	OptionsHelp = 0x0,
	OptionsList,
	OptionsDevice,
	OptionsApp,
	OptionsCount
};

static struct option long_options[OptionsCount] = {
	{"help", no_argument, 0x0, 'h'},
	{"list", no_argument, 0x0, 'l'},
	{"device", required_argument, 0x0, 'd'},
	{"app", required_argument, 0x0, 'a'}
};

static bool optionsEnable[OptionsCount] = {};

int main(int argc, const char * argv[]) {
	SDMMobileDevice;
	
	char *udid = NULL;
	char *app_path = NULL;
	
	bool searchArgs = true;
	
	int counter;
	while (searchArgs) {
		int option_index = 0x0;
		counter = getopt_long (argc, (char * const *)argv, "lhd:a:",long_options, &option_index);
		if (counter == -1) {
			break;
		}
		switch (counter) {
			case 'h': {
				optionsEnable[OptionsHelp] = true;
				searchArgs = false;
				break;
			};
			case 'l': {
				optionsEnable[OptionsList] = true;
				searchArgs = false;
				break;
			};
			case 'd': {
				if (optarg && !optionsEnable[OptionsDevice]) {
					optionsEnable[OptionsDevice] = true;
					udid = optarg;
				}
				break;
			}
			case 'a': {
				if (optarg && !optionsEnable[OptionsApp]) {
					app_path = optarg;
					optionsEnable[OptionsApp] = true;
				}
				else {
					printf("please specify an .app path");
				}
				break;
			};
			default: {
				break;
			};
		}
	}
	if (optionsEnable[OptionsHelp]) {
		printf("%s : list attached devices\n",listArg);
		printf("%s [UDID] : specify a device\n",deviceArg);
		printf("%s [.app path] : install specificed .app to a device\n",appArg);
	}
	if (optionsEnable[OptionsList]) {
		ListConnectedDevices();
	}
	if (optionsEnable[OptionsApp]) {
		if (udid != NULL) {
			TranferAppForInstallOnDevice(udid, app_path);
			InstallApplicationOnDevice(udid, app_path);
		} else {
			InstallAppOnFirstDevice(app_path);
		}
	}
	
	return 0;
}
