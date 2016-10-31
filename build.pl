#!/usr/bin/env perl -w

use PrepareAndroidSDK;
use File::Path;
use strict;
use warnings;

sub BuildAndroid
{
	# If the ANDROID_NDK_ROOT is already set, assume someone else has prepared the NDK for us.
	# This will happen when being built by our mono build scripts
	my $ndkRootToUse = "";
	if ("$ENV{ANDROID_NDK_ROOT}" ne "")
	{
		$ndkRootToUse = $ENV{ANDROID_NDK_ROOT};
	}
	else
	{
		PrepareAndroidSDK::GetAndroidSDK(undef, undef, "r10e");
		$ndkRootToUse = $ENV{ANDROID_NDK_ROOT};
	}

	system('$ANDROID_NDK_ROOT/ndk-build clean');
	system('$ANDROID_NDK_ROOT/ndk-build');
}

sub ZipIt
{
	system("mkdir -p build/temp/include") && die("Failed to create temp directory.");

	# write build info
	my $git_info = qx(git symbolic-ref -q HEAD && git rev-parse HEAD);
	open(BUILD_INFO_FILE, '>', "obj/local/armeabi/build.txt") or die("Unable to write build information to build/temp/build.txt");
	print BUILD_INFO_FILE "$git_info";
	close(BUILD_INFO_FILE);

	system("cd obj/local/armeabi && zip ../../../builds.zip -r *.a build.txt") && die("Failed to package libraries into zip file.");
}

my $runningUnderMonoBuild = 0;
if ("$ENV{ANDROID_NDK_ROOT}" ne "")
{
	$runningUnderMonoBuild = 1;
}

BuildAndroid();

# If we are running as part of the mono build, don't zip it, because we don't need the zip
if (!$runningUnderMonoBuild)
{
	ZipIt();
}