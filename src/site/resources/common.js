<!-- Common javascript functions for the demo site -->

function docCertificate() {
	//Doesn't work?  :-(
	  document.writeln("  <center>");
	  document.writeln("  	Since Java 1.7u51, to use the applet, you'll need to install our root certificate.");
	  document.writeln("  	Before the applet was auto-signed. But now, you'll have to install");
	  document.writeln("  	<a href="certificates/cacert.crt">this certificate (update 17 January 2014)</a> as a certificate authority.");
	  document.writeln("  	Your browser will install it. For details, take a look at ");
	  document.writeln("  	<a href='howto-sign.html#How_to_import_the_certificate_in_your_browser'>this page</a>,");
	  document.writeln("  	especially if you're using Firefox.");
	  document.writeln("  </center>");
}

  


function footer() {
  document.writeln("  <center>");
  document.writeln("      <table width=100% cellpadding=0 cellspacing=0 border=0>");
  document.writeln("       <tr><td colspan=3><hr size=1 noshade width=100%></td></tr>");
  document.writeln("       <tr>");
  document.writeln("        <td NOWRAP><A HREF='http://sourceforge.net/projects/jupload/'>Sourceforge page</A>&nbsp;|&nbsp;");
  document.writeln("            <A HREF='index.html'>Home Page (Demo)</A>&nbsp;|&nbsp;");
  document.writeln("            <A HREF='README.txt'>Release Notes</A>");
  document.writeln("            &nbsp; &nbsp;");
  document.writeln("        </td>");
  document.writeln("        <td><A href='http://sourceforge.net'><IMG src='images/sourceforge_logo.gif' border='0' alt='SourceForge Logo'></A></td>");
  document.writeln("       </tr>");
  document.writeln("       <tr>");
  document.writeln("        <td colspan=2>");
  document.writeln("            Demo: ");
  document.writeln("              <A HREF='applet-basic.html'>basic</A>,");
  document.writeln("              <A HREF='applet-basic-picture.html'>picture mode</A>,");
  document.writeln("              <A HREF='advanced_js_demo.html'>advanced demo</A>");
  document.writeln("        </td>");
  document.writeln("       </tr>");
  document.writeln("       <tr>");
  document.writeln("        <td colspan=2>");
  document.writeln("            Doc:");
  document.writeln("            <A HREF='apidocs/index.html'>javadoc</A>, &nbsp; ");
  document.writeln("            <A HREF='howto-debug.html'>HowTo debug it</A>, &nbsp; ");
  document.writeln("            <A HREF='howto-compile.html'>HowTo compile it</A>, &nbsp; ");
  document.writeln("            <A HREF='howto-support.html'>HowTo get support</A>, &nbsp; ");
  document.writeln("            <A HREF='howto-customize.html'>HowTo customize it</A>");
  document.writeln("            	(<A HREF='apidocs/wjhk/jupload2/policies/package-summary.html'>UploadPolicy</A>, ");
  document.writeln("            	<A HREF='apidocs/wjhk/jupload2/filedata/package-summary.html'>FileData</A>) &nbsp; ");
  document.writeln("            <A HREF='howto-translate.html'>HowTo translate it</A>");
  document.writeln("        </td>");
  document.writeln("       </tr>");
  document.writeln("       <tr><td colspan=3><hr size=1 noshade width=100%></td></tr>");
  document.writeln("       <tr><td colspan=3><b>Note</b>: This demo is updated automatically from the SVN repository.<br />Therefore, this demo may contain features which are <b>not yet</b> available from regular downloads!</td></tr>");
  document.writeln("      </table>");
  document.writeln("  </center>");
}

