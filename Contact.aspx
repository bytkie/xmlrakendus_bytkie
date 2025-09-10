<%@ Page Title="Contact" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="xmlrakendus_bytkie.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main>
        <h1>XML katsetamine: Bogdan sugupuu</h1>


        <asp:Xml runat="server" DocumentSource="~/Bogdan2sugupuu.xml" TransformSource="~/Bogdan2paring.xslt" />
    </main>
</asp:Content>
