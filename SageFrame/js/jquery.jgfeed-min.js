/*
 * jGFeed 1.0 - Google Feed API abstraction plugin for jQuery
 *
 * Copyright (c) 2009 jQuery HowTo
 *
 * Licensed under the GPL license:
 *   //www.gnu.org/licenses/gpl.html
 *
 * URL:
 *   //jquery-howto.blogspot.com
 *
 * Author URL:
 *   //me.boo.uz
 *
 */
(function($){$.extend({jGFeed:function(url,fnk,num,key){if(url==null){return false;}var gurl="//ajax.googleapis.com/ajax/services/feed/load?v=1.0&callback=?&q="+url;if(num!=null){gurl+="&num="+num;}if(key!=null){gurl+="&key="+key;}$.getJSON(gurl,function(data){if(typeof fnk=="function" && data.responseData!==null){fnk.call(this,data.responseData.feed);}else{  fnk.call(this,data.responseData);return false;}});}});})(jQuery);
