#!/usr/bin/python3
''' Creates improved trajectories for all videos in a directory from
the UCF dataset.'''

import argparse
import os

PARSER = argparse.ArgumentParser()

PARSER.add_argument("-s", "--source_dir", type=str, required=True,
                    default="UCF")
PARSER.add_argument("-d", "--dest_dir", type=str, required=True)

ARGS = PARSER.parse_args()

for category in os.listdir(ARGS.source_dir):

    category_source_dir = ARGS.source_dir + '/' + category
    print("Current source folder: ", category_source_dir)

    category_dest_dir = ARGS.dest_dir + '/' + category
    os.mkdir(category_dest_dir)

    for vid in os.listdir(category_source_dir):
        source_file = category_source_dir + '/' + vid

        # Dest file is obtained by replacing the video extension with .bin
        dest_file = category_dest_dir + '/' + vid[:-4] + '.bin'

        cmd = 'improved_trajectory/src2/release/DenseTrackStab -f ' \
              + source_file + ' -o ' + dest_file
        os.system(cmd)
