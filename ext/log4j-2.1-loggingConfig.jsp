<%-- IMPORTS AND SETUP --%>
<%@ page import="org.apache.logging.log4j.Level" %>
<%@ page import="org.apache.logging.log4j.LogManager" %>
<%@ page import="org.apache.logging.log4j.core.Logger" %>
<%@ page import="org.apache.logging.log4j.core.LoggerContext" %>
<%@ page import="org.apache.logging.log4j.core.config.LoggerConfig" %>
<%@ page import="org.apache.logging.log4j.core.config.AbstractConfiguration" %>

<%@ include file="/html/common/init.jsp" %>
<%@ taglib uri="/WEB-INF/tld/dotmarketing.tld" prefix="dot" %>
<portlet:defineObjects/>
<%@ include file="/html/common/messages_inc.jsp" %>

<%-- LOGIC --%>
<% 
	// Check for variables - if passed, we'll need to set logging
	Logger thisLogger = (Logger) LogManager.getLogger("Activator");
	boolean values_passed = false;
	String success_message = "";
	String error_message = "";
	String className = request.getParameter("java_class_name");
	String level = request.getParameter("debug_type");
	
	// Check if values were passed, set boolean to flag
	if(className != null && !className.equals("") 
			&& level != null && !level.equals("")) {
		// Setting a level: both class and level were sent
		values_passed = true;
		try {
	   		  Logger log = ((Logger) LogManager.getLogger(className));
	   		  Level logLevel = Level.toLevel(level);
			
			  System.out.println("Changing logger: " + log.getName() + "   to level: " + level.toString());
			  String loggerName = log.getName();

			  LoggerContext ctx = (LoggerContext)LogManager.getContext(false);
			  AbstractConfiguration conf = (AbstractConfiguration) ctx.getConfiguration();
			  
			  if (conf.getLogger(loggerName) != null) {
				    LoggerConfig loggerConfig = conf.getLoggerConfig(loggerName);
				    loggerConfig.setLevel(logLevel);
				  } else {
				    LoggerConfig loggerConfig = new LoggerConfig(loggerName, logLevel, true);
				    conf.addLogger(loggerName, loggerConfig);
				  }
			  
			ctx.updateLoggers(conf);
	   		thisLogger.info("Log4jConfig Portlet: " + className + " just set to level " + level);
	   		success_message = "Successfully set " + className + " to " + level + "."; 
	   	} catch(Exception e) {
	   		error_message = "Log4jConfig Portlet: Error occurred setting " + className 
				+ " to level " + level + ". Error is: " + e.toString();
	   		thisLogger.error(error_message);
	   	}
	} else if(className != null && !className.equals("")) {
		// Lookup Level: just class was passed
		values_passed = true;
		try {
			level = LogManager.getLogger(className).getLevel().toString();
			success_message = className + " is currently set to: " + level + ".";
	   	} catch(Exception e) {
	   		error_message = "Log4jConfig Portlet: Error occurred getting " + className 
				+ " level. <strong>The level for this package or class is probably not set yet.</strong>"
   				+ " Error is: " + e.toString();
	   		thisLogger.error(error_message);
	   	}
	}
%>

<%-- HTML --%>
<style>
	#log4j-config-portlet {
		text-align:center;
	}
	h1 {
		margin: 20px 10px;
	}
	div.fieldWrapper {
		margin: 10px 0px;
		display: inline-block;
	}
	.fieldName {
		text-align: left;
	}
	#portlet-action-bar {
		margin: 15px 0px;
	}
	#notification-center {
		width: 40%;
		margin: 10px auto;
		color: #fff;
	}
	#notification-center .success {
		background: #27ae60;
		padding: 10px 15px;
	}
	#notification-center .error {
		background: #c0392b;
		padding: 10px 15px;
		word-break: break-all;
	}
	#portlet_action_bar {
		margin: 18px 0px;	
	}
	a#log4j-save,
	a#log4j-cancel {
		padding: 3px 10px;
	}
</style>

<div id="log4j-config-portlet" class="portlet-wrapper">
	
	<form id="log4j-config" action="" method="post">
		<h1>Log4j Configuration</h1>
		<p>If you do not provide a level but provide a class/package, the current level will be displayed.</p>
		
		<!-- For messaging -->
		<%
		if(values_passed) {
		%>
			<div id="notification-center">
				<%
				if(error_message.equals("")) {
					// Success
				%>
					<div class="success">
						<%= success_message %>
					</div>
				<%
				} else {
					// Error occurred
				%>
					<div class="error">
						<%= error_message %>
					</div>
				<%
				}
				%>
			</div>
		<%
		}
		%>
	
		<!-- Class Name -->
		<div class="fieldWrapper">
			<div class="fieldName" id="class_name_tag">
				<span class="required2">Java Class or Package (include full classpath):</span>
			</div>
			<div class="fieldValue" id="class_name_value">
				<div class="dijit dijitReset dijitInline dijitLeft dijitTextBox"
						id="class_name">
					<div class="dijitReset dijitInputField dijitInputContainer">
						<input class="dijitReset dijitInputInner" 
								name="java_class_name" type="text" tabindex="0" id="java_class_name"
								placeholder="Ex: java.util.List" value=""/>
					</div>
				</div>
			</div>
		</div>
		<div>
			<div class="clear"></div>
		</div>
		
		<!-- Debug Type -->
		<hr/>
		<div class="fieldWrapper">
			<div class="fieldName" id="debug_type_tag">
				<span class="required2">Select a Level to Change Logging:</span>
			</div>
			<div class="fieldValue" id="debug_type_field">
				<div class="dijit dijitReset dijitInline dijitLeft" id="widget_debug_type">
					<select id="debug_type" name="debug_type" onchange="setupSaveButton(); return false;">
						<option value="">Select level...</option>
						<option value="ALL">ALL (Most Verbose)</option>
						<option value="TRACE">TRACE</option>
						<option value="INFO">INFO</option>
						<option value="DEBUG">DEBUG</option>
						<option value="WARN">WARN</option>
						<option value="ERROR">ERROR</option>
						<option value="FATAL">FATAL</option>
						<option value="OFF">OFF (Least Verbose)</option>
					</select>
				</div>
			</div>
		</div>
		<div>
			<div class="clear"></div>
		</div>
		
		<!-- It's Go Time -->
		<div id="portlet_action_bar">
			<a id="log4j-save" class="dijitReset dijitInline dijitButtonNode" onclick="saveConfiguration();">
				Get Level
			</a>
			<a id="log4j-cancel" class="dijitReset dijitInline dijitButtonNode" onclick="cancelConfiguration();">
				<span class="cancelIcon"></span>
				Cancel
			</a>
		</div>
	</form>
</div>

<!-- JavaScript to run commands -->
<script>
	// Called when the drop down for debug type changes and will change text on the save button
	function setupSaveButton() {
		var ddl = document.getElementById("debug_type");
		if(ddl.options[ddl.selectedIndex].value === "") {
			document.getElementById("log4j-save").innerHTML = "Get Level";	
		} else {
			document.getElementById("log4j-save").innerHTML = "<span class='saveIcon'></span>Save";			
		}
	}

	// Resets the form
	function cancelConfiguration() {
		document.getElementById("java_class_name").value = "";
		document.getElementById("debug_type").selectedIndex = 0;
	}
	
	// Runs to make sure values in form are set to proceed
	function saveConfiguration() {
		// Check if values are set
		var valid = true;
		if(document.getElementById("java_class_name").value === "") {
			valid = false;
			alert("Please provide a java class name.");
		}
		
		// Save results if form is valid
		if(valid) {
			document.getElementById("log4j-config").submit();
		}
	}
</script>