<%@ Control Language="C#" ClassName="ArenaWeb.UserControls.custom.johnsonferry.TableAnarchy"  Inherits="Arena.Portal.PortalControl" %>

<%@ Import Namespace="Arena.Core" %>
<%@ Import Namespace="Arena.Portal" %>

<script runat="server">
    [TextSetting("Table Selector", "The CSS selector (i.e.: 'table.classname' or '.classname>table#mainTableId') that will be used to identify the table that is to be transformed. If there is more than one table, a semicolon delimited list of CSS selectors may be entered.", false)]
    public string TableSelectorSetting { get { return Setting("TableSelector", "table", false); } }

    [TextSetting("Label Class", "The CSS class that is used to identify field labels in the table. (Check the HTML of the TABLE you are transforming. If the data cells (TD) that contain form field labels have a specific class name, specify it here.)", false)]
    public string LabelClassSetting { get { return Setting("LabelClass", "", false); } }

    [TextSetting("Main Container Class (optional)", "This will be the class given to the new container that is created from the original table. Having a specific class for the main container will make it easier to apply CSS rules to the container's child elements.", false)]
    public string ContainerClassSetting { get { return Setting("ContainerClass", "", false); } }

    [BooleanSetting("Assume 'For' Attributes of Labels", "[WORKS ONLY IF MATCHING 'Label Class' IS FOUND IN TABLE] In most cases with table-built forms, the INPUT fields will directly follow their LABEL text. Setting this option to TRUE will cause the module to assume that this is the case. If an accurate 'Label Class' has also been specified, the module will attempt to link form fields with their labels by using a matching 'name' and 'for' attribute in each, respectively. If the resulting HTML does not seem to be coming out correctly, set this option to FALSE. Default 'false'", false, false)]
    public bool AssumeForSetting { get { return Convert.ToBoolean(Setting("AssumeFor", "false", false)); } }

    private void Page_Load(object sender, EventArgs e)
    {
      
      
        System.Text.StringBuilder sb = new System.Text.StringBuilder();
        sb.Append(@"<script language='javascript'>" + Environment.NewLine);
        sb.Append(@"$(document).ready(function() {" + Environment.NewLine);
        sb.Append(@"/* This code pulls the contents of a TABLE's data cells out of the TABLE " + Environment.NewLine);
        sb.Append(@"and into individual containers. Any class names of the original data cells " + Environment.NewLine);
        sb.Append(@"are also transferred to the new containers.*/" + Environment.NewLine);
        sb.Append(@"    //Set all variables." + Environment.NewLine);
        sb.Append(@"    var " + Environment.NewLine);
        sb.Append(@"    tableSelectorSetting = '" + TableSelectorSetting + "'," + Environment.NewLine);
        sb.Append(@"    labelClassSetting = '" + LabelClassSetting + "'," + Environment.NewLine);
        sb.Append(@"    optionalMainContainerClass = '" + ContainerClassSetting + "'," + Environment.NewLine);
        sb.Append(@"        aTableSelectors," + Environment.NewLine);
        sb.Append(@"        currentSelector," + Environment.NewLine);
        sb.Append(@"        tableRows, tableCells, className, contents, $newCont1, $newCont2, $newCont3;" + Environment.NewLine);
        sb.Append(@"" + Environment.NewLine);
        sb.Append(@"    aTableSelectors = tableSelectorSetting.split(';');" + Environment.NewLine);
        sb.Append(@"" + Environment.NewLine);
        sb.Append(@"    for (currentSelector in aTableSelectors) {" + Environment.NewLine);
        sb.Append(@"" + Environment.NewLine);
        sb.Append(@"        //Create a main container to hold the moved table cell elements." + Environment.NewLine);
        sb.Append(@"        $newCont1 = $('<div />');" + Environment.NewLine);
        sb.Append(@"        if (optionalMainContainerClass) {" + Environment.NewLine);
        sb.Append(@"            $newCont1.addClass(optionalMainContainerClass);" + Environment.NewLine);
        sb.Append(@"        }" + Environment.NewLine);
        sb.Append(@"" + Environment.NewLine);
        sb.Append(@"        //Place the main container just above the existing table." + Environment.NewLine);
        sb.Append(@"        $(aTableSelectors[currentSelector]).before($newCont1);" + Environment.NewLine);
        sb.Append(@"" + Environment.NewLine);
        sb.Append(@"        //Get all table rows from the table, saving them in a JS object." + Environment.NewLine);
        sb.Append(@"        tableRows = $( aTableSelectors[currentSelector] + ' tr' );" + Environment.NewLine);
        sb.Append(@"" + Environment.NewLine);
        sb.Append(@"        //Loop through each item in the JS object." + Environment.NewLine);
        sb.Append(@"        $.each(tableRows, function( count, item ) {" + Environment.NewLine);
        sb.Append(@"            $newCont2 = $('<div />');" + Environment.NewLine);
        sb.Append(@"" + Environment.NewLine);
        sb.Append(@"            //Copy any table row's attributes to the current item" + Environment.NewLine);
        sb.Append(@"            $(item).each(function() {" + Environment.NewLine);
        sb.Append(@"                $.each(this.attributes, function(i, attrib){" + Environment.NewLine);
        sb.Append(@"                    var name = attrib.name;" + Environment.NewLine);
        sb.Append(@"                    var value = attrib.value;" + Environment.NewLine);
        sb.Append(@"                    $newCont2.attr(name, value);" + Environment.NewLine);
        sb.Append(@"                });" + Environment.NewLine);
        sb.Append(@"            });" + Environment.NewLine);
        sb.Append(@"" + Environment.NewLine);
        sb.Append(@"            //Detach all table cells from the current item, saving them in a JS object." + Environment.NewLine);
        sb.Append(@"            tableCells = $(item).children().detach();" + Environment.NewLine);
        sb.Append(@"" + Environment.NewLine);
        sb.Append(@"            //Loop through each item in the JS object." + Environment.NewLine);
        sb.Append(@"            $.each( tableCells, function( count, item ) {" + Environment.NewLine);
        sb.Append(@"                className = $(item).attr('class');" + Environment.NewLine);
        sb.Append(@"                contents = $(item).contents();" + Environment.NewLine);
        sb.Append(@"                if (className === labelClassSetting) {" + Environment.NewLine);
        sb.Append(@"                    //Create a new container with the same class as the existing item." + Environment.NewLine);
        sb.Append(@"                    $newCont3 = $('<label />');" + Environment.NewLine);
        sb.Append(@"                } else {" + Environment.NewLine);
        sb.Append(@"                    $newCont3 = $('<div />');" + Environment.NewLine);
        sb.Append(@"                }" + Environment.NewLine);
        sb.Append(@"" + Environment.NewLine);
        sb.Append(@"                //Add the contents of the item to the new container." + Environment.NewLine);
        sb.Append(@"                $newCont3.append(contents).addClass(className);" + Environment.NewLine);
        sb.Append(@"" + Environment.NewLine);
        sb.Append(@"                /*Add class to container to indicate which table column it originally came " + Environment.NewLine);
        sb.Append(@"                  from. This will provide an additional method for styling the content.*/" + Environment.NewLine);
        sb.Append(@"                $newCont3.addClass( 'col' + (count + 1).toString() );" + Environment.NewLine);
        sb.Append(@"" + Environment.NewLine);
        sb.Append(@"                //Add the new container to the main container." + Environment.NewLine);
        sb.Append(@"                $newCont2.append($newCont3);" + Environment.NewLine);
        sb.Append(@"            });" + Environment.NewLine);
        sb.Append(@"" + Environment.NewLine);
        sb.Append(@"            //Add a break at the end of the container so that the items will wrap correctly." + Environment.NewLine);
        sb.Append(@"            $newCont2.append('<br />');" + Environment.NewLine);
        sb.Append(@"            $newCont1.append($newCont2);" + Environment.NewLine);
        sb.Append(@"        });" + Environment.NewLine);
        sb.Append(@"" + Environment.NewLine);
        sb.Append(@"        //Remove the now empty original table." + Environment.NewLine);
        sb.Append(@"        $( aTableSelectors[currentSelector] ).remove();" + Environment.NewLine);
        sb.Append(@"    }" + Environment.NewLine);
        sb.Append(@"});" + Environment.NewLine);
      
        sb.Append(@"</scr" + "ipt>" + Environment.NewLine + Environment.NewLine);
        
        //Page.Header.Controls.Add(new LiteralControl(sb.ToString()));
        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "tableanarchy", sb.ToString());
    }
</script>


