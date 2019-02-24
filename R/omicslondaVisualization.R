#' Visualize Longitudinal Feature
#'
#' Visualize Longitudinal Feature
#'
#' @param df dataframe has the Count, Group, ID, Time
#' @param text feature name
#' @param group.levels The two level's name
#' @param unit time interval unit
#' @param col two color to be used for the two groups (eg., c("red", "blue")).
#' @param ylabel text to be shown on the y-axis of all generated figures (default: "Normalized Count")
#' @param prefix prefix to be used to create directory for the analysis results
#' @import ggplot2
#' @import grDevices
#' @import graphics
#' @references
#' Ahmed Metwally (ametwall@stanford.edu)
#' @export
visualizeFeature = function (df, text, group.levels, unit = "days", ylabel = "Normalized Count", 
                             col = c("blue", "firebrick"), prefix = "Test")
{
  cat("Visualizing Feature = ", text, "\n")
  Count=0; Time=0; Subject=0; Group=0 ## This line is just to pass the CRAN checks for the aes in ggplot2
  
  p = ggplot(df, aes(Time, Count, colour = Group, group = interaction(Group, Subject)))
  p = p + geom_point(size = 1, alpha = 0.5) + geom_line(size = 1, alpha = 0.7) +  theme_bw() +
    ggtitle(paste("Feature = ", text, sep = "")) + labs(y = ylabel, x = sprintf("Time (%s)", unit)) +
    scale_colour_manual(values = col, breaks = c("0", "1"),
                        labels = c(group.levels[1], group.levels[2])) +
    theme(axis.text.x = element_text(colour="black", size=12, angle=0, hjust=0.5, vjust=0.5, face="bold"),
          axis.text.y = element_text(colour="black", size=12, angle=0, hjust=0.5, vjust=0.5, face="bold"),
          axis.title.x = element_text(colour="black", size=15, angle=0, hjust=.5, vjust=0.5, face="bold"),
          axis.title.y = element_text(colour="black", size=15, angle=90, hjust=.5, vjust=.5, face="bold"),
          legend.text=element_text(size=15, face="plain"), legend.title = element_blank(), 
          plot.title = element_text(hjust = 0.5)) +
    theme(legend.position="top") + scale_x_continuous(breaks = waiver())

  ggsave(filename=paste(prefix, "/", "Feature_", text, ".jpg", sep=""), dpi = 1200, height = 10, width = 15, units = 'cm')
}



#' Visualize the feature trajectory with the fitted Splines
#'
#' Plot the longitudinal features along with the fitted splines
#'
#' @param df dataframe has the Count , Group, ID, Time
#' @param model the fitted model
#' @param method The fitting method (ssgaussian)
#' @param group.levels The two level's name
#' @param text feature name
#' @param unit time unit used in the Time vector (hours, days, weeks, months, etc.)
#' @param col two color to be used for the two groups (eg., c("red", "blue")).
#' @param ylabel text to be shown on the y-axis of all generated figures (default: "Normalized Count")
#' @param prefix prefix to be used to create directory for the analysis results
#' @import ggplot2
#' @import grDevices
#' @import graphics
#' @references
#' Ahmed Metwally (ametwall@stanford.edu)
#' @export
visualizeFeatureSpline = function (df, model, method, text, group.levels, unit = "days", ylabel = "Normalized Count", 
                                   col = c("blue", "firebrick"), prefix = "Test")
{ 
  cat("Visualizing Splines of Feature = ", text, "\n")
    
  Count=0;Time=0;Subject=0;Group=0;lnn=0 ## This line is just to pass the CRAN checks for the aes in ggplot2
  dd.null = model$dd.null
  dd.0 = model$dd.0
  dd.1 = model$dd.1
  
  #cat("v0.7", "\n")
  ln = factor(c(rep("longdash", nrow(df)), rep("longdash", nrow(dd.0)), rep("longdash", nrow(dd.1))))
  size = c(rep(1, nrow(df)), rep(1, nrow(dd.0)), rep(1, nrow(dd.1)))
  #cat("v0.9", "\n")
  head(df)
  head(dd.0)
  head(dd.1)
  dm = rbind(df[,c("Time", "Count", "Group", "Subject")], dd.0[,c("Time", "Count", "Group", "Subject")], dd.1[,c("Time", "Count", "Group", "Subject")])
  #cat("v0.92", "\n")
  dm$lnn=ln
  #cat("v0.96", "\n")
  dm$sz= size
  
  p = ggplot(dm, aes(Time, Count, colour = Group, group = interaction(Group, Subject)))
  
  #cat("v1.0", "\n")
  p = p + theme_bw() + geom_point(size=1, alpha=0.5) + geom_line(aes(linetype=lnn), size=1, alpha=0.5) + 
    ggtitle(paste("Feature = ", text, sep = "")) + labs(y = ylabel, x = sprintf("Time (%s)", unit)) +
    scale_colour_manual(values = c(col, "darkblue", "darkgreen"), 
                        breaks = c("0", "1", "fit.0", "fit.1"),
                        labels = c(group.levels[1], group.levels[2], paste(group.levels[1], ".fit", sep=""), paste(group.levels[2], ".fit", sep="")))+
    theme(axis.text.x = element_text(colour="black", size=12, angle=0, hjust=0.5, vjust=0.5, face="bold"),
          axis.text.y = element_text(colour="black", size=12, angle=0, hjust=0.5, vjust=0.5, face="bold"),
          axis.title.x = element_text(colour="black", size=15, angle=0, hjust=.5, vjust=0.5, face="bold"),
          axis.title.y = element_text(colour="black", size=15, angle=90, hjust=.5, vjust=.5, face="bold"), 
          legend.text=element_text(size=15, face="plain"), legend.title = element_blank(),
          plot.title = element_text(hjust = 0.5)) +
    theme(legend.position="top") + scale_x_continuous(breaks = waiver()) + guides(linetype=FALSE, size =FALSE)
  
  ggsave(filename=paste(prefix, "/", "Feature_", text, "_CurveFitting_", method, ".jpg", sep=""), dpi = 1200, height = 10, width = 15, units = 'cm')
}



visualizeFeatureSpline_permute = function (df, model, method, text, group.levels, unit = "days", ylabel = "Normalized Count", 
                                   col = c("blue", "firebrick"), prefix = "Test")
{ 
  #cat("Visualizing Splines of Feature = ", text, "\n")
  
  Count=0;Time=0;Subject=0;Group=0;lnn=0 ## This line is just to pass the CRAN checks for the aes in ggplot2
  dd.null = model$dd.null
  dd.0 = model$dd.0
  dd.1 = model$dd.1
  
  #cat("v0.7", "\n")
  ln = factor(c(rep("longdash", nrow(df)), rep("longdash", nrow(dd.0)), rep("longdash", nrow(dd.1))))
  size = c(rep(1, nrow(df)), rep(1, nrow(dd.0)), rep(1, nrow(dd.1)))
  #cat("v0.9", "\n")
  head(df)
  head(dd.0)
  head(dd.1)
  dm = rbind(df[,c("Time", "Count", "Group", "Subject")], dd.0[,c("Time", "Count", "Group", "Subject")], dd.1[,c("Time", "Count", "Group", "Subject")])
  #cat("v0.92", "\n")
  dm$lnn=ln
  #cat("v0.96", "\n")
  dm$sz= size
  
  p = ggplot(dm, aes(Time, Count, colour = Group, group = interaction(Group, Subject)))
  
  #cat("v1.0", "\n")
  p = p + theme_bw() + geom_point(size=1, alpha=0.5) + geom_line(aes(linetype=lnn), size=1, alpha=0.5) + 
    ggtitle(paste("Feature = ", text, sep = "")) + labs(y = ylabel, x = sprintf("Time (%s)", unit)) +
    scale_colour_manual(values = c(col, "yellow", "brown"), 
                        breaks = c("0", "1", "fit.0", "fit.1"),
                        labels = c(group.levels[1], group.levels[2], paste(group.levels[1], ".fit", sep=""), paste(group.levels[2], ".fit", sep="")))+
    theme(axis.text.x = element_text(colour="black", size=12, angle=0, hjust=0.5, vjust=0.5, face="bold"),
          axis.text.y = element_text(colour="black", size=12, angle=0, hjust=0.5, vjust=0.5, face="bold"),
          axis.title.x = element_text(colour="black", size=15, angle=0, hjust=.5, vjust=0.5, face="bold"),
          axis.title.y = element_text(colour="black", size=15, angle=90, hjust=.5, vjust=.5, face="bold"), 
          legend.text=element_text(size=15, face="plain"), legend.title = element_blank(),
          plot.title = element_text(hjust = 0.5)) +
    theme(legend.position="top") + scale_x_continuous(breaks = waiver()) + guides(linetype=FALSE, size =FALSE)
  
  ggsave(filename=paste(prefix, "_Feature_", text, "_CurveFitting_", method, ".jpg", sep=""), dpi = 1200, height = 10, width = 15, units = 'cm')
}


#' Visualize significant time interval
#'
#' Visualize significant time interval
#'
#' @param model.ss The fitted model
#' @param method Fitting method (ssgaussian)
#' @param start Vector of the start points of the time intervals
#' @param end Vector of the end points of the time intervals
#' @param text Feature name
#' @param group.levels Level's name
#' @param unit time unit used in the Time vector (hours, days, weeks, months, etc.)
#' @param col two color to be used for the two groups (eg., c("red", "blue")).
#' @param ylabel text to be shown on the y-axis of all generated figures (default: "Normalized Count")
#' @param prefix prefix to be used to create directory for the analysis results
#' @import ggplot2
#' @import grDevices
#' @import graphics
#' @references
#' Ahmed Metwally (ametwall@stanford.edu)
#' @export
visualizeArea = function(model.ss, method, start, end, text, group.levels, unit = "days", 
                         ylabel = "Normalized Count", col = c("blue", "firebrick"), prefix = "Test")
{
  cat("Visualizing Significant Intervals of Feature = ", text, "\n")
  Time = 0 ## This line is just to pass the CRAN checks for the aes in ggplot2
  sub.11 = list()
  sub.10 = list()
  xx = NULL
  for(i in 1:length(start))
  {
    sub.11[[i]] = subset(model.ss$dd.1, Time >= start[i] & Time <= end[i])  
    sub.10[[i]] = subset(model.ss$dd.0, Time >= start[i] & Time <= end[i])
    cmd = sprintf('geom_ribbon(data=sub.10[[%d]], aes(ymin = sub.11[[%d]]$Count, ymax = Count), colour= "grey3", fill="grey69", 
                  alpha = "0.6")', i, i)
    if (i != 1)
    {
      xx = paste(xx, cmd, sep = "+")
    } else
    {
      xx = cmd
    }
  }
  
  # ddNULL = model_ss$ddNULL
  dd.0 = model.ss$dd.0
  dd.1 = model.ss$dd.1
  
  dm = rbind(dd.0, dd.1)
  p1 = 'ggplot(dm, aes(Time, Count, colour = Group, group = interaction(Group, Subject))) + 
  theme_bw() + geom_point(size = 1, alpha = 0.5) + geom_line(size = 1, alpha = 0.5) + 
  ggtitle(paste("Feature = ", text, sep = "")) + labs(y = ylabel, x = sprintf("Time (%s)", unit)) +
  scale_colour_manual(values = col, 
  breaks = c("fit.0", "fit.1"),
  labels = c(paste(group.levels[1], ".fit", sep = ""), paste(group.levels[2], ".fit", sep = ""))) +
  theme(axis.text.x = element_text(colour = "black", size = 12, angle = 0, hjust = 0.5, vjust = 0.5, face = "bold"),
  axis.text.y = element_text(colour = "black", size = 12, angle = 0, hjust = 0.5, vjust = 0.5, face = "bold"),
  axis.title.x = element_text(colour = "black", size = 15, angle = 0, hjust = 0.5, vjust = 0.5, face = "bold"),
  axis.title.y = element_text(colour = "black", size = 15, angle = 90, hjust = 0.5, vjust = 0.5, face = "bold"), 
  legend.text = element_text(size = 15, face="plain"), legend.title = element_blank(),
  plot.title = element_text(hjust = 0.5)) +
  theme(legend.position = "top") + scale_x_continuous(breaks = waiver())' 
  p2 = xx  
  p3 = paste(p1, p2, sep="+")
  p = eval(parse(text = p3))
  ggsave(filename=paste(prefix, "/", "Feature_", text, "_SignificantInterval_", method, ".jpg", sep=""), dpi = 1200, height = 10, width = 15, units = 'cm')
}



#' Visualize all significant time intervals for all tested features
#'
#' Visualize all significant time intervals for all tested features
#'
#' @param interval.details Dataframe has infomation about significant interval (feature name, start, end, dominant, p-value)
#' @param prefix prefix for the output figure
#' @param unit time unit used in the Time vector (hours, days, weeks, months, etc.)
#' @param col two color to be used for the two groups (eg., c("red", "blue")).
#' @param fit.method fitting method (ssguassian).
#' @import ggplot2
#' @import grDevices
#' @import graphics
#' @references
#' Ahmed Metwally (ametwall@stanford.edu)
#' @export
visualizeTimeIntervals = function(interval.details, prefix = "Test", unit = "days", 
                                  col = c("blue", "firebrick"), fit.method = "ssgaussian")
{
  feature=0;dominant=0;Subject=0;Group=0;lnn=0 ## This line is just to pass the CRAN checks for the aes in ggplot2
  interval.details$dominant = as.factor(interval.details$dominant)
  interval.details$pvalue = as.numeric((interval.details$pvalue))
  interval.details = interval.details[order(interval.details$feature), ]
  
  ### TODO: Specify min and max
  
  ggplot(interval.details, aes(ymin = start , ymax = end, x = feature, xend = feature)) + 
    geom_linerange(aes(color = dominant), size = 1) + 
    coord_flip() +  scale_colour_manual(values = col) +
    labs(x = "Feature", y = sprintf("Time (%s)", unit), colour="Dominant") + 
     theme(axis.text.x = element_text(colour = "black", size = 10, angle = 0, hjust = 0.5, vjust = 0.5, face = "bold"),
           axis.text.y = element_text(colour = "black", size = 8, angle = 0, vjust = 0.5, face = "bold"),
           axis.title.x = element_text(colour = "black", size = 15, angle = 0, hjust = 0.5, vjust = 0.5, face = "bold"),
           axis.title.y = element_text(colour = "black", size = 15, angle = 90, hjust = 0.5, vjust = 0.5, face = "bold"),
           legend.text = element_text(size = 15, face = "plain")) + 
    theme(panel.grid.minor =   element_blank(),
          panel.grid.major.y = element_line(colour = "white", size = 6),
          panel.grid.major.x = element_line(colour = "white",size = 0.75)) +
    theme(legend.position="top", panel.border = element_rect(colour = "black", fill = NA, size = 2))
  ggsave(filename = paste(prefix, "/OmicsLonDA_TimeIntervals_", fit.method, "_", prefix, ".jpg", sep=""), dpi = 1200, height = 30, width = 20, units = 'cm')
}




#' Visualize Test Statistics empirical distribution
#'
#' Visualize Test Statistics empirical distribution for each time interval
#'
#' @param permuted Permutation of the permuted data
#' @param text Feature name
#' @param method fitting method
#' @param prefix prefix to be used to create directory for the analysis results
#' @param modelStat test statistics
#' @import ggplot2
#' @import grDevices
#' @import graphics
#' @references
#' Ahmed Metwally (ametwall@stanford.edu)
#' @export
visualizeTestStatHistogram = function(permuted, text, method, prefix = "Test", modelStat){
  cat("Visualizing testStat Distribution for Feature = ", text, "\n")
  n = length(modelStat)
  r = ceiling(sqrt(n))
  c = ceiling(sqrt(n))
  xx = paste(prefix, "/", "Feature_", text, "_testStat_distribution_ALL_INTERVALL_", method, ".jpg", sep = "")
  #jpeg(filename = xx, res = 1200, height = r*5, width = c*5, units = 'cm')
  jpeg(filename = xx, res = 1200, height = 40, width = 40, units = 'cm')
  

  minPoint = min(min(permuted), min(modelStat))
  maxPoint = max(max(permuted), max(modelStat))
  
  par(mfrow=c(r,c))
  for(i in 1:n){
    hist(permuted, xlab = "testStat", 
         breaks = 100, col = "gray", border = "gray", 
         main = paste("Interval # ", i, sep=""), xlim = c(minPoint, maxPoint), freq = TRUE)
    abline(v = modelStat[i], col="red")
  }
  dev.off()
}
