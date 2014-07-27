package com.weedenwright.dotcms.plugins.logconfig.portlet;

import com.dotmarketing.osgi.GenericBundleActivator;
import org.osgi.framework.BundleContext;

public class Activator extends GenericBundleActivator {

	public void start ( BundleContext context ) throws Exception { 

		//************************************************************
		//*******************LOAD ANY DESIRED CLASSES*****************
		//************************************************************
		// This is where you would add any dynamic classes that are 
		// exported by other dynamic plugins
		// Class.forName("com.example.plugin.test.ExampleExportedClass");

		//************************************************************
		//*******************REGISTER THE PORTLETS********************
		//************************************************************
		//Register our portlets
		String[] xmls = new String[]{"conf/portlet.xml", "conf/liferay-portlet.xml"};
		registerPortlets( context, xmls );
	}

	public void stop ( BundleContext context ) throws Exception {
		// Unregister all the bundle services
		unregisterServices( context );
	}
}