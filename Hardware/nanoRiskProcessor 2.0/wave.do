view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue HiZ -period 100ps -dutycycle 50 -starttime 0ps -endtime 100000ps sim:/nanoRiskProcessor2/clk 
WaveCollapseAll -1
wave clipboard restore
