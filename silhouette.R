library(dplyr)
library(zeallot)

set.seed(100)

c(n1,n2,n3) %<-% c(3,3,3)
c(x1_mu,x2_mu,x3_mu) %<-% c(0,10,-10)
c(y1_mu,y2_mu,y3_mu) %<-% c(0,10,10)
c(x1_sd,x2_sd,x3_sd) %<-% c(2,1,1)
c(y1_sd,y2_sd,y3_sd) %<-% c(1,1,1)

x <- c(rnorm(n1,x1_mu,x1_sd), rnorm(n2,x2_mu,x2_sd), rnorm(n3,x3_mu,x3_sd))
y <- c(rnorm(n1,y1_mu,y1_sd), rnorm(n2,y2_mu,y3_sd), rnorm(n3,y3_mu,y3_sd))
plot(x,y)

n <- n1+n2+n3
data <- data.frame(id=1:n,x,y)

kmeans_model <- stats::kmeans(data,3)

distance <- function(x_i,y_i,x_j,y_j){
  sqrt((x_i-x_j)^2 + (y_i-y_j)^2)
}
distance(0,0,1,1)

expand.grid(i=1:n,j=1:n) %>% 
  dplyr::mutate(x_i = x[i], y_i = y[i], c_i = kmeans_model$cluster[i],
                x_j = x[j], y_j = y[j], c_j = kmeans_model$cluster[j],
                d_ij = distance(x_i,y_i,x_j,y_j)) %>% 
  dplyr::group_by(j,c_i) %>% 
  dplyr::mutate(n=n(),
                sum_d_ij = sum(d_ij),
                same_c = c_i == c_j,
                n=n()) %>% 
  dplyr::ungroup() %>% 
  dplyr::group_by(j) %>% 
  dplyr::mutate(a_j = sum_d_ij[same_c]/(n-1),
                b_j = min(sum_d_ij[!same_c])/n )


