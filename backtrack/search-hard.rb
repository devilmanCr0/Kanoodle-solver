require "pry-byebug"
#require "pry-rescue"
GRID_COLUMN     = 11
GRID_ROW        = 5

=begin
        There are 8 pieces that can be defined in a 3x3 grid
        there are 4 pieces that can be defined in a 2x4 grid
=end

# These tiles are defined in a 3x3 grid
x_tile = [[0,1,0], [1,1,1], [0,1,0]]
zzag_tile = [[2,0,0],[2,2,0],[0,2,2]]
short_L_tile = [[0,0,0],[0,0,3],[3,3,3]]
lshort_L_tile = [[0,0,4],[0,0,4],[4,4,4]]
cube_tile = [[5,5,0],[5,5,0],[0,0,0]]
cube_s_tile = [[0,0,6],[0,6,6],[0,6,6]]
m_tile = [[0,7,7],[0,7,0],[0,7,7]]
small_L_tile = [[0,0,0],[0,8,0],[0,8,8]]

# These tiles are defined in a 4x4 grid
mosin_tile = [[9,0,0,0],[9,9,0,0], [9,0,0,0], [9,0,0,0]]
stick_tile = [[10,0,0,0],[10,0,0,0],[10,0,0,0],[10,0,0,0]]
long_L_tile = [[11,0,0,0],[11,0,0,0],[11,0,0,0],[11,11,0,0]]
curve_L_tile = [[0,12,0,0],[12,12,0,0],[12,0,0,0],[12,0,0,0]]


def print_matrix(matrix)
        for i in matrix
                p i
        end

        p "------------------"
end

# Will rotate tile based off a mix of rotate transpose and reverse
def rotate_tile(tile)
        # annaershova.github.io/blog/2015/07/22/how-to-rotate-a-matrix-in-ruby/
        rotated_tile = []
        tile.transpose.each do |x|
                rotated_tile << x.reverse
        end

        return rotated_tile
end

# Will flip a tile 
def flip(tile)
       # We only need to worry about two types of tiles so i'll be lazy tonight baby
       flipped_tile = []
       tile.each do |x|
                flipped_tile << x.reverse
       end

       return flipped_tile
end

def place(grid, tile, row, col, dx, dc)
        new_grid = grid.map(&:clone)
        tile.each_with_index do | r, x |
                r.each_with_index do | c, y |
                        next if c == 0
                        new_grid[x+row-dx][y+col-dc] = c
                end
        end
        return new_grid
end

def does_overlap(grid, tile, row, col, dr, dc)
        
        tile.each_with_index do | r, x |
                r.each_with_index do | c, y |
                        # Checks if the relative position of tile
                        # and global position of grid is occupied
                        # dirty bug here
                        if c != 0 and grid[x+row-dr][y+col-dc] != 0
                                return true
                        end
                end
        end

        false
end

def isinvalid(row, col)
        grid_row = GRID_ROW
        grid_col = GRID_COLUMN
        if row >= grid_row or row < 0 or col >= grid_col or col < 0 
               return true
        end
        return false
end

def out_of_bounds(grid, tile, row, col, dx, dc)
        

        tile.each_with_index do | r, x |
                r.each_with_index do | c, y |
                        return true if (isinvalid(x+row-dx, y+col-dc) and c != 0)
                end
        end

        return false
end

def map_tiles(row, col, piece)
     piece_true_pos = []
     piece.each_with_index do |x, r|
        x.each_with_index do |y, c|
                if y != 0
                        piece_true_pos << [row+r, col+c]
                end
        end
     end
     return piece_true_pos
end


def find_free_space(grid)
     
     # Using map_tile, we will check every direction for each position to
     # see if there is free space adjacent to the current tile
     
     piece_true_pos = []

     grid.each_with_index do | x , r |
        x.each_with_index do | y , c |
                if y == 0
                        piece_true_pos << [r,c]
                end
        end
     end
     # only select positions that are valid and next to occupied tiles
     

     free_tiles = []
     # This logic will produce duplicate positions that are unecessary, please fix somehow
     for r, c in piece_true_pos
               next if r == nil or c == nil
               potential_spots = [[r+1, c],[r, c+1],[r-1, c],[r, c-1]]
               for pr, pc in potential_spots
                       next if isinvalid(pr, pc) 
                       if grid[pr][pc] != 0
                                free_tiles << [r, c]
                                break
                       end
               end
     end
     return free_tiles
end

def log_level(array,grid,piece,r,c)
        puts "-------------------------------------------"
        puts "LOGGING RECURSION LEVEL TO BE #{array.length}"
        puts "FOLLOWING GRID IS "
        print_matrix grid
        puts "FOLLOWING ARRAY IS "
        print_matrix array
        puts "PIECE FOR THIS GRID FOR POSITION #{r.to_s}#{c.to_s}| IS "
        print_matrix piece
        puts "-------------------------------------------"
        
end

def backtrack(array, grid, row, col)
        print array.length
        # Should return the grid if we've explored all puzzle pieces for this path
        #  binding.pry if array.length == 1
        # maybe we should have a condition that checks if there is any more avaliable space?
        # if there isn't.. don't try to run this entire path again
        
        #if array.length == 1 and no_more_viable_space(grid, array)
        if array.length == 0  # FIX LIMIT
                
                print_matrix grid
                exit
                return [grid, array]
        end

        max = []
        # Update the grid without the selected tilepiece
        array.each_with_index do | jigsaw, jigsaw_index |
              piece = jigsaw.map(&:clone)
              # There's going to be another type of iterator to go through
              # All the adjacent free spaces of the current tile we are on
              # It shouldn't be just free space from the previous tile, but all of them
              position_list = find_free_space(grid)
              potential_paths = []
              for r, c in position_list
                       # binding.pry if level == 4
                       #log_level(array,grid,piece,r,c)
                       potential_placement = []
                       for pr, pc in map_tiles(r, c, piece)
                               rotation_count = 0
                               flipped = false
                               while rotation_count < 4
                                      
                                       diff_r = pr-r         
                                       diff_c = pc-c
                                       
                                       # We need to figure out a way to recalibrate the piece so that
                                       # it's exactly on the free spot point, shift left right top down whatever
                                       # Everything will crumble if it can't close the spaces together
                                       if not out_of_bounds(grid, piece, r, c, diff_r, diff_c)
                                              if not does_overlap(grid, piece, r, c, diff_r, diff_c)
                                                        potential_placement << place(grid, piece, r, c, diff_r, diff_c)
                                              end
                                       end

                                       rotation_count += 1
                                       if rotation_count == 4 and not flipped
                                               rotation_count = 0
                                               piece = flip piece
                                               flipped = true 
                                               next
                                       end

                                       piece = rotate_tile piece
                               end

                               # If we reach here, that means we have not found an optimal grid, so return nada
                               #return []
                        end

                        # for each valid placement, discover a new path from there
                        # MAKE SURE TO n=+1
                        for new_grid in potential_placement
                                array_copy = array.map(&:clone)
                                array_copy.delete_at jigsaw_index
                                  
                                   binding.pry if new_grid == [[2, 2,  3,   3,  3, 0, 0, 0,  0,  0, 0],
                                        [9, 2,  2,   8,  3, 0, 0, 0,  0,  0, 0],
                                        [9, 9,  2,   8,  8, 0, 0, 0,  0,  0, 0],
                                        [9, 6,  6,   6, 11, 11,11,11, 0,  0, 0],
                                        [9, 6,  6,  10, 10, 10,10,11, 0,  0, 0]]
                                  potential_paths << backtrack(array_copy, new_grid, r, c)
                        end
               end
                
                # There is nothing else we can do if we find no potential paths
               if potential_paths.length == 0
                        array << [] # add junk to up the number and filter this one out
                        return [grid, array]
               end

               potential_max = [potential_paths[0][0], potential_paths[0][1]]
               #potential_max = potential_paths[0] if potential_paths != 0
               potential_paths.each do | possible_grid |
                        potential_max = possible_grid if possible_grid[1].length < potential_max[1].length
               end
               
               

               #grid = potential_max[0]
               #array = potential_max[1]
               max << potential_max
        end
        absolute_max = [ max[0][0], max[0][1] ] 
        max.each do | maxest |
               absolute_max = maxest if maxest[1].length < absolute_max[1].length
        end
         
        grid = absolute_max[0]
        array = absolute_max[1]
         
        return [grid, array]
end

# Start off with an empty grid of 11 columns per row
grid = Array.new(GRID_ROW) { Array.new(GRID_COLUMN, 0) }
        # Easy
grid2 = [[12, 12, 4, 4,  4, 10, 10, 10, 10, 7, 7],
        [3, 12, 12, 12, 4, 11, 0,   0, 0,  0, 7],
        [3, 3,  3,   1, 4, 11, 0,   0, 0,  7, 7],
        [6, 6,  1,   1, 1, 11, 0,   0, 0,  0, 0],
        [6, 6,  6,   1, 11, 11, 0,  0, 0,  0, 0]] 
        
        # Easy
puzzle_tiles2 = [mosin_tile, zzag_tile, small_L_tile, cube_tile ]
        
        # FINAL
grid1 = [[2, 2,  3,   3,  3, 0, 0, 0, 0, 0, 0],
        [9, 2,  2,   8,  3, 0, 0, 0, 0,  0, 0],
        [9, 9,  2,   8,  8, 0, 0, 0, 0,  0, 0],
        [9, 6,  6,   6,  0, 0, 0, 0, 0,  0, 0],
        [9, 6,  6,  10, 10, 10, 10,  0, 0,  0, 0]] 

        # FINAL
puzzle_tiles1 = [long_L_tile, lshort_L_tile, curve_L_tile, cube_tile, m_tile, x_tile ]


        # Difficult
grid3 =[[2, 2,  3,   3,  3, 7, 7, 0,  0,  0, 0],
        [9, 2,  2,   8,  3, 7, 0, 0,  0,  0, 0],
        [9, 9,  2,   8,  8, 7, 7, 0,  0,  0, 0],
        [9, 6,  6,   6, 11, 11,11,11, 0,  0, 0],
        [9, 6,  6,  10, 10, 10,10,11, 0,  0, 0]] 

        # Difficult
puzzle_tiles3 = [x_tile, lshort_L_tile, curve_L_tile, cube_tile]

        # test
gridtest = [[2, 2,  3,   3,  3, 0, 0, 0, 0, 0,  0],
            [9, 2,  2,   8,  3, 0, 0, 0, 0, 12, 0],
            [9, 9,  2,   8,  8, 0, 0, 0, 12,12, 0],
            [9, 6,  6,   6,  0, 0, 0, 0, 12, 0, 0],
            [9, 6,  6,  10, 10, 10,10,0, 12, 0, 0]] 

        # test
puzzle_tilestest = [m_tile, x_tile, long_L_tile, lshort_L_tile ]
puzzle_tilestest2 = [x_tile, long_L_tile, lshort_L_tile, m_tile ]
puzzle_tilestest3 =  [long_L_tile, lshort_L_tile, cube_tile, m_tile, x_tile ]

# Provide an initial piece and place it anywhere within the grid
print_matrix backtrack(puzzle_tilestest2, gridtest, 0, 0)[0]
print "Finished"


