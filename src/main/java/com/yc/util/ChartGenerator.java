package com.yc.util;

import java.math.BigDecimal;
import java.util.Map;

/**
 * Generates SVG charts using pure Java (no JavaScript required)
 */
public class ChartGenerator {

    /**
     * Generates a bar chart as SVG string
     */
    public static String generateBarChart(Map<String, BigDecimal> data, int width, int height, String barColor) {
        if (data == null || data.isEmpty()) {
            return generateEmptyChart(width, height, "No data available");
        }

        StringBuilder svg = new StringBuilder();
        svg.append(String.format("<svg width='%d' height='%d' xmlns='http://www.w3.org/2000/svg'>", width, height));
        
        // Background
        svg.append(String.format("<rect width='%d' height='%d' fill='#f9f9f9' rx='10'/>", width, height));
        
        int padding = 50;
        int chartWidth = width - (padding * 2);
        int chartHeight = height - (padding * 2) - 30;
        int barCount = data.size();
        int barWidth = Math.max(30, (chartWidth / barCount) - 20);
        int gap = (chartWidth - (barWidth * barCount)) / (barCount + 1);
        
        // Find max value for scaling
        BigDecimal maxValue = data.values().stream()
                .max(BigDecimal::compareTo)
                .orElse(BigDecimal.ONE);
        
        if (maxValue.compareTo(BigDecimal.ZERO) == 0) {
            maxValue = BigDecimal.ONE;
        }

        // Draw grid lines
        for (int i = 0; i <= 4; i++) {
            int y = padding + (chartHeight * i / 4);
            svg.append(String.format("<line x1='%d' y1='%d' x2='%d' y2='%d' stroke='#ddd' stroke-dasharray='5,5'/>",
                    padding, y, width - padding, y));
            
            BigDecimal labelValue = maxValue.multiply(BigDecimal.valueOf(4 - i)).divide(BigDecimal.valueOf(4), 0, BigDecimal.ROUND_HALF_UP);
            svg.append(String.format("<text x='%d' y='%d' font-size='10' fill='#666' text-anchor='end'>%s</text>",
                    padding - 5, y + 4, labelValue.toString()));
        }

        // Draw bars
        int x = padding + gap;
        for (Map.Entry<String, BigDecimal> entry : data.entrySet()) {
            double ratio = entry.getValue().doubleValue() / maxValue.doubleValue();
            int barHeight = (int) (chartHeight * ratio);
            int barY = padding + chartHeight - barHeight;
            
            // Bar with rounded top
            svg.append(String.format("<rect x='%d' y='%d' width='%d' height='%d' fill='%s' rx='5' ry='5'/>",
                    x, barY, barWidth, barHeight, barColor));
            
            // Value on top of bar
            svg.append(String.format("<text x='%d' y='%d' font-size='11' fill='#333' text-anchor='middle' font-weight='bold'>%s</text>",
                    x + barWidth / 2, barY - 5, entry.getValue().toString()));
            
            // Label below bar
            String label = entry.getKey().length() > 3 ? entry.getKey().substring(0, 3) : entry.getKey();
            svg.append(String.format("<text x='%d' y='%d' font-size='11' fill='#333' text-anchor='middle'>%s</text>",
                    x + barWidth / 2, height - padding + 20, label));
            
            x += barWidth + gap;
        }

        svg.append("</svg>");
        return svg.toString();
    }

    /**
     * Generates a doughnut/pie chart as SVG string
     * Legend is placed below the chart to prevent overlap
     */
    public static String generateDoughnutChart(Map<String, Integer> data, int size, String[] colors) {
        if (data == null || data.isEmpty()) {
            return generateEmptyChart(size, size + 100, "No data available");
        }

        int legendHeight = data.size() * 25 + 20;
        int totalHeight = size + legendHeight;
        
        StringBuilder svg = new StringBuilder();
        svg.append(String.format("<svg width='%d' height='%d' xmlns='http://www.w3.org/2000/svg'>", size, totalHeight));
        
        int centerX = size / 2;
        int centerY = size / 2 - 20;
        int outerRadius = (size / 2) - 40;
        int innerRadius = outerRadius - 35;
        
        // Calculate total
        int total = data.values().stream().mapToInt(Integer::intValue).sum();
        if (total == 0) {
            return generateEmptyChart(size, totalHeight, "No data available");
        }

        double startAngle = -90; // Start from top
        int colorIndex = 0;

        for (Map.Entry<String, Integer> entry : data.entrySet()) {
            double percentage = (double) entry.getValue() / total;
            double sweepAngle = percentage * 360;
            
            if (sweepAngle > 0) {
                String color = colors[colorIndex % colors.length];
                
                // Draw arc segment
                svg.append(drawArcSegment(centerX, centerY, outerRadius, innerRadius, startAngle, sweepAngle, color));
                
                startAngle += sweepAngle;
            }
            colorIndex++;
        }

        // Center text
        svg.append(String.format("<text x='%d' y='%d' font-size='24' fill='#333' text-anchor='middle' font-weight='bold'>%d</text>",
                centerX, centerY + 5, total));
        svg.append(String.format("<text x='%d' y='%d' font-size='11' fill='#666' text-anchor='middle'>Total</text>",
                centerX, centerY + 22));

        // Legend below chart - horizontal layout
        int legendStartY = size - 20;
        int legendX = 20;
        int itemWidth = (size - 40) / 3; // 3 items per row
        colorIndex = 0;
        int itemsInRow = 0;
        
        for (Map.Entry<String, Integer> entry : data.entrySet()) {
            String color = colors[colorIndex % colors.length];
            
            svg.append(String.format("<rect x='%d' y='%d' width='12' height='12' fill='%s' rx='2'/>",
                    legendX, legendStartY, color));
            svg.append(String.format("<text x='%d' y='%d' font-size='11' fill='#333'>%s: %d</text>",
                    legendX + 16, legendStartY + 11, capitalize(entry.getKey()), entry.getValue()));
            
            itemsInRow++;
            if (itemsInRow >= 3) {
                legendX = 20;
                legendStartY += 22;
                itemsInRow = 0;
            } else {
                legendX += itemWidth;
            }
            colorIndex++;
        }

        svg.append("</svg>");
        return svg.toString();
    }

    /**
     * Generates a horizontal bar chart for top products
     */
    public static String generateHorizontalBarChart(Map<String, Integer> data, int width, int height, String barColor) {
        if (data == null || data.isEmpty()) {
            return generateEmptyChart(width, height, "No data available");
        }

        StringBuilder svg = new StringBuilder();
        svg.append(String.format("<svg width='%d' height='%d' xmlns='http://www.w3.org/2000/svg'>", width, height));
        
        // Background
        svg.append(String.format("<rect width='%d' height='%d' fill='#fff' rx='10'/>", width, height));
        
        int padding = 20;
        int labelWidth = 120;
        int chartWidth = width - labelWidth - (padding * 2);
        int barCount = data.size();
        int barHeight = Math.min(30, (height - padding * 2) / barCount - 10);
        int gap = 10;
        
        // Find max value
        int maxValue = data.values().stream().max(Integer::compareTo).orElse(1);
        if (maxValue == 0) maxValue = 1;

        int y = padding;
        for (Map.Entry<String, Integer> entry : data.entrySet()) {
            double ratio = (double) entry.getValue() / maxValue;
            int barWidth = (int) (chartWidth * ratio);
            
            // Label
            String label = entry.getKey();
            if (label.length() > 15) label = label.substring(0, 15) + "...";
            svg.append(String.format("<text x='%d' y='%d' font-size='11' fill='#333' text-anchor='start'>%s</text>",
                    padding, y + barHeight / 2 + 4, label));
            
            // Bar
            svg.append(String.format("<rect x='%d' y='%d' width='%d' height='%d' fill='%s' rx='4'/>",
                    labelWidth + padding, y, barWidth, barHeight, barColor));
            
            // Value
            svg.append(String.format("<text x='%d' y='%d' font-size='11' fill='#fff' text-anchor='end' font-weight='bold'>%d</text>",
                    labelWidth + padding + barWidth - 5, y + barHeight / 2 + 4, entry.getValue()));
            
            y += barHeight + gap;
        }

        svg.append("</svg>");
        return svg.toString();
    }

    private static String drawArcSegment(int cx, int cy, int outerR, int innerR, double startAngle, double sweepAngle, String color) {
        // Convert angles to radians
        double startRad = Math.toRadians(startAngle);
        double endRad = Math.toRadians(startAngle + sweepAngle);
        
        // Calculate points
        int x1 = (int) (cx + outerR * Math.cos(startRad));
        int y1 = (int) (cy + outerR * Math.sin(startRad));
        int x2 = (int) (cx + outerR * Math.cos(endRad));
        int y2 = (int) (cy + outerR * Math.sin(endRad));
        int x3 = (int) (cx + innerR * Math.cos(endRad));
        int y3 = (int) (cy + innerR * Math.sin(endRad));
        int x4 = (int) (cx + innerR * Math.cos(startRad));
        int y4 = (int) (cy + innerR * Math.sin(startRad));
        
        int largeArc = sweepAngle > 180 ? 1 : 0;
        
        return String.format("<path d='M%d,%d A%d,%d 0 %d,1 %d,%d L%d,%d A%d,%d 0 %d,0 %d,%d Z' fill='%s'/>",
                x1, y1, outerR, outerR, largeArc, x2, y2,
                x3, y3, innerR, innerR, largeArc, x4, y4, color);
    }

    private static String generateEmptyChart(int width, int height, String message) {
        return String.format(
            "<svg width='%d' height='%d' xmlns='http://www.w3.org/2000/svg'>" +
            "<rect width='%d' height='%d' fill='#f9f9f9' rx='10'/>" +
            "<text x='%d' y='%d' font-size='14' fill='#999' text-anchor='middle'>%s</text>" +
            "</svg>",
            width, height, width, height, width / 2, height / 2, message);
    }

    private static String capitalize(String str) {
        if (str == null || str.isEmpty()) return str;
        return str.substring(0, 1).toUpperCase() + str.substring(1).toLowerCase();
    }
}
