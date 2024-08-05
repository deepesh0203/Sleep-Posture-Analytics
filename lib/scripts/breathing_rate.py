import os
from scipy import interpolate
from scipy.signal import find_peaks
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import sys

def generate_breathing_rate_plot(file_path):
    # Read the data into a DataFrame
    df = pd.read_csv(file_path, sep='\t', header=None)

    # Subtract previous row from each row
    df = df.sub(df.shift(1), fill_value=0)
    row_sums = df.iloc[30:60, :768].sum(axis=1)

    # Interpolate to make the curve look continuous
    x = np.arange(30, 30 + len(row_sums))  # X-axis values
    f = interpolate.interp1d(x, row_sums, kind='cubic')
    x_new = np.linspace(30, 30 + len(row_sums) - 1, 10 * len(row_sums))  # New X-axis values with increased density
    y_smooth = f(x_new)

    peaks, _ = find_peaks(y_smooth)
    peak_diffs = np.diff(x_new[peaks])

    # Calculate the average difference between peaks
    average_peak_diff = np.mean(peak_diffs)

    breathing_rate = 60 / average_peak_diff  # Breaths per minute

    # Plot how the sum changes through the rows with magnification and smoothing
    plt.figure(figsize=(12, 8))
    plt.plot(x_new, y_smooth)
    plt.plot(x_new[peaks], y_smooth[peaks], "x", markersize=10, color='red')
    plt.title('D[t]-D[t-1]')
    plt.xlabel('Time')
    plt.ylabel('Pressure Sum')
    plt.grid(True)

    # Add text annotation for breathing rate below the plot
    plt.text(0.5, -0.1, f'Average Breathing Rate: {breathing_rate:.2f} breaths/min', transform=plt.gca().transAxes,
             fontsize=12, verticalalignment='top', horizontalalignment='center', backgroundcolor='white')

    # Save the plot as an image in the tmp directory
    plot_path = os.path.join('tmp', 'plot.png')
    plt.savefig(plot_path)

if __name__ == "__main__":
    file_path = sys.argv[1]
    generate_breathing_rate_plot(file_path)
