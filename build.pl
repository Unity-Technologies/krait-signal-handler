#!/usr/bin/env perl -w

use PrepareAndroidSDK;
use File::Path;
use strict;
use warnings;

sub BuildAndroid
{
	PrepareAndroidSDK::GetAndroidSDK(undef, undef, "r16b");
	system('$ANDROID_NDK_ROOT/ndk-build clean');
	system('$ANDROID_NDK_ROOT/ndk-build');
}

sub ZipIt
{
	system("mkdir -p build/temp/include") && die("Failed to create temp directory.");

	# write build info
	my $git_info = qx(echo $GIT_BRANCH && echo $GIT_REVISION);
	open(BUILD_INFO_FILE, '>', "obj/local/armeabi-v7a/build.txt") or die("Unable to write build information to build/temp/build.txt");
	print BUILD_INFO_FILE "$git_info";
	close(BUILD_INFO_FILE);

	system("cd obj/local/armeabi-v7a && zip ../../../builds.zip -r *.a build.txt") && die("Failed to package libraries into zip file.");
}

BuildAndroid();
ZipIt();
