library("shiny")

shinyServer(function(input, output) {
  output$plot1 <- renderPlot({
    set.seed(1)
    x1 <- runif(input$nobs, 0, 1)
    x2 <- runif(input$nobs, 0, 1)
    y <- input$b0 + 
         (input$b1 * x1) + 
         (input$b2 * x2) + 
         (input$b3 * x1 * x2) + rnorm(input$nobs)
    m <- lm(as.formula(input$modelformula))
    
    nx <- seq(0, 1, length.out = input$density)
    z <- outer(nx, nx, FUN = function(a, b) predict(m, data.frame(x1 = a, x2 = b)))
    par(mar = rep(1, 4))
    p <- persp(nx, nx, z, 
          xlab = input$xlab, ylab = input$ylab, zlab = input$zlab,
          r = input$distance,
          theta = input$theta, phi = input$phi, shade = input$shade, 
          col = input$color, border = input$border,
          ltheta = input$ltheta, lphi = input$lphi,
          box = input$box, axes = input$axes, 
          ticktype = input$ticktype, nticks = input$nticks)
    if (!is.na(input$me_x1)) {
      lines(trans3d(x = rep(as.numeric(input$me_x1), 2), y = c(0,1), 
                    z = predict(m, data.frame(x1 = rep(as.numeric(input$me_x1), 2), x2 = c(0,1))), 
                    pmat = p), 
            col = input$me_x1_color, lwd = 2)
    }
    if (!is.na(input$me_x2)) {
      lines(trans3d(x = c(0,1), y = rep(as.numeric(input$me_x2), 2),
                    z = predict(m, data.frame(x1 = c(0,1), x2 = rep(as.numeric(input$me_x2), 2))), 
                    pmat = p), 
            col = input$me_x2_color, lwd = 2)
    }
  })
  
  output$downloadImage <- downloadHandler(
    filename = "perspective.png",
    content = function(file) {
      png(file)
      plotInput()
      dev.off()
    },
    contentType = "image/png"
  )
})
