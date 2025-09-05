<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="xmlrakendus_bytkie._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <main>
        <h1>XML katsetamine: Elizaveta II sugupuu</h1>

            <asp:Xml runat="server" DocumentSource="~/Elisaveta2sugupuu.xml" TransformSource="~/Elizaveta2paring.xslt" />
    </main>

</asp:Content>
