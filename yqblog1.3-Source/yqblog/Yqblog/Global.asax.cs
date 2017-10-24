using System;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using System.Globalization;
using System.Threading;
using Yqblog.General;

namespace Yqblog
{
    public class MvcApplication : HttpApplication
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new HandleErrorAttribute());
            filters.Add(new BlogActionAttributeFilter()); 
        }

        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
                "Index",
                "{p}",
                new { controller = "Home", action = "Index", p = UrlParameter.Optional },
                new { p = "[0-9]*" }
            );

            routes.MapRoute(
                "Rss",
                "rss/",
                new { controller = "Home", action = "Rss" }
            );

            routes.MapRoute(
                "CommentRss",
                "commentrss/",
                new { controller = "Home", action = "CommentRss" }
            );

            routes.MapRoute(
                "Category",
                "cate/{id}/{p}",
                new { controller = "Home", action = "Category", p = UrlParameter.Optional },
                new { id = "[0-9]+", p = "[0-9]*" }
            );

            routes.MapRoute(
                "Article",
                "archive/{key}",
                new { controller = "Home", action = "ArticleByKey" },
                new { key = @"^[a-zA-Z0-9\-]+$" }
            );

            routes.MapRoute(
                "Album",
                "album/{key}",
                new { controller = "Home", action = "AlbumByKey" },
                new { key = @"^[a-zA-Z0-9\-]+$" }
            );

            routes.MapRoute(
                "Tag",
                "tag/{key}/{p}",
                new { controller = "Home", action = "Tag", p = UrlParameter.Optional },
                new { p = "[0-9]*" }
            );

            routes.MapRoute(
                "User",
                "u/{user}",
                new { controller = "Account", action = "UView"}
            );

            routes.MapRoute(
                "Search",
                "search/{key}/{p}",
                new { controller = "Home", action = "Search", p = UrlParameter.Optional },
                new { p = "[0-9]*" }
            );


            routes.MapRoute(
                "Author",
                "author/{user}",
                new { controller = "Home", action = "Author" }
            );

            routes.MapRoute(
                "Archives",
                "archives/{year}/{month}/{day}",
                new { controller = "Home", action = "Archives", month = UrlParameter.Optional, day = UrlParameter.Optional },
                new { year = "[0-9]+", month = "[0-9]*", day = "[0-9]*" }
            );


            routes.MapRoute(
                "CategoryByKey",
                "{key}/{p}",
                new { controller = "Home", action = "CategoryByKey", p = UrlParameter.Optional },
                new { key = @"^[a-zA-Z0-9\-]+$", p = "[0-9]*" }
            );

            routes.MapRoute(
                "Default",
                "{controller}/{action}/{id}",
                new { controller = "Home", action = "Index", id = UrlParameter.Optional }
            );
        }

        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            RegisterGlobalFilters(GlobalFilters.Filters);
            RegisterRoutes(RouteTable.Routes);
        }

        protected void Application_AcquireRequestState(object sender, EventArgs e)
        {
            if (HttpContext.Current.Session == null) return;
            var defaultlang = WebUtils.Configinfo.DefaultLang == "zh-cn" ? "" : WebUtils.Configinfo.DefaultLang;
            var currentlang = Session["CurrentLanguage"] != null ? Session["CurrentLanguage"].ToString() : defaultlang;

            var ci =(CultureInfo)Session["CurrentLanguage"];
            if (ci == null)
            {
                ci = new CultureInfo(currentlang);
                Session["CurrentLanguage"] = ci;
            }

            if (!Request.Url.AbsoluteUri.ToLower().Contains("admin"))
            {
                var lang = Array.Find(WebUtils.Langs, element => Request.Url.AbsoluteUri.ToLower().IndexOf(element, StringComparison.Ordinal) > -1);
                ci = !string.IsNullOrWhiteSpace(lang) ? new CultureInfo(lang.Trim('/')) : new CultureInfo(currentlang);
                Session["CurrentLanguage"] = ci;
            }

            Thread.CurrentThread.CurrentUICulture = ci;
            Thread.CurrentThread.CurrentCulture =CultureInfo.CreateSpecificCulture(ci.Name);
        }

        protected void Session_Start(object sender, EventArgs e)
        {
            WebUtils.ChangeThemeViaLang(WebUtils.Configinfo.DefaultLang);
        }
    }
}