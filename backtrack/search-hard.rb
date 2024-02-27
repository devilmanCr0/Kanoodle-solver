
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

puzzle_tiles = [zzag_tile, short_L_tile, lshort_L_tile, cube_tile, cube_s_tile, m_tile, 
small_L_tile, mosin_tile, stick_tile, long_L_tile, curve_L_tile]

# Will rotate tile based off a mix of rotate transpose and reverse
def rotate_tile(tile)
        # annaershova.github.io/blog/2015/07/22/how-to-rotate-a-matrix-in-ruby/
        rotated_tile = []
        tile.transpose.each do |x|
                rotated_tile << x.reverse
        end

        rotated_tile
end

# Will flip a tile 
def flip(tile)
       # We only need to worry about two types of tiles so i'll be lazy tonight baby
       flipped_tile = []
       tile.each do |x|
                flipped_tile << x.reverse
       end

       flipped_tile
end

def place(grid, tile, row, col)
        new_grid = grid.map(&:clone)
        tile.each_with_index do | r, x |
                r.each_with_index do | c, y |
                        new_grid[x+row][y+col] = c
                end
        end
        return new_grid
end

def does_overlap(grid, tile, row, col)
        
        tile.each_with_index do | r, x |
                r.each_with_index do | c, y |
                        # Checks if the relative position of tile
                        # and global position of grid is occupied 
                        if c != 0 and grid[x+row][y+col] != 0
                                false
                        end
                end
        end

        true
end

def isinvalid(row, col)
        grid_row = GRID_ROW
        grid_col = GRID_COLUMN
        if row < grid_row or row > grid_row or
        col < grid_col or col > grid_col
               true 
        end

        false
end

def out_of_bounds(grid, tile, row, col)
        tile.each_with_index do | r, x |
                r.each_with_index do | c, y |
                        false if c != 0 and isinvalid(x+row, y+col)
                end
        end

        true
end

# Where are all the tiles pieces on the grid? this will help determine the free spaces
def map_tile(grid, row, col, tile_num)
        # Determine which tile we are one, this is easy because every tile is represented with a different
        # number
        if isinvalid(row, col)
                return []
        end
        if grid[row][col] != tile_num
                return []
        end 
        
        # Returns an array of two elements representing or row col
        return [row, col] + [find_free_space(grid, row+1, col, tile_num)] 
        + [find_free_space(grid, row, col+1, tile_num)]
        + [find_free_space(grid, row+1, col+1, tile_num)]
        + [find_free_space(grid, row-1, col-1, tile_num)]
        + [find_free_space(grid, row, col-1, tile_num)]
        + [find_free_space(grid, row-1, col, tile_num)]
        + [find_free_space(grid, row+1, col-1, tile_num)]
        + [find_free_space(grid, row-1, col+1, tile_num)]
        + [find_free_space(grid, row, col, tile_num)]
end

def find_free_space(grid, row, col, piece)
     
     # Using map_tile, we will check every direction for each position to
     # see if there is free space adjacent to the current tile
     
     # Find a way to locate our tile, center the row and col to any point of our tile
     # screw you
     tile_num = 0
     print piece
     piece.each do |x|
        x.each do |y|
                if y != 0
                        tile_num = y
                end
        end
     end
     
     # change this later so you can recalibrate where your tile piece actual is in the grid space
     grid.each_with_index do |x, sigma|
        x.each_with_index do |y, beta|
                if y == tile_num
                        row = sigma
                        col = beta
                end
        end
     end
 
     free_tiles = []
     for r, c in map_tile(grid, row, col, tile_num)
               next if r == nil or c == nil
               potential_spots = [[r+1, c],[r, c+1],[r-1, c],[r, c-1]]
               for pr, pc in potential_spots
                       next if isinvalid(pr, pc) or grid[pr][pc] != 0
                       free_tiles += [[pc, pr]]
               end
     end

     return free_tiles
end


def backtrack(array, grid, n, row, col, initial_piece)

        # Should return the grid if we've explored all puzzle pieces for this path
        if n == array.length
                return grid
        end
        # Update the grid without the selected tilepiece
        array.drop(n).each do | jigsaw |
              piece = jigsaw.map(&:clone)
              # There's going to be another type of iterator to go through
              # All the adjacent free spaces of the current tile we are on
              position_list = find_free_space(grid, row, col, initial_piece)
              for r, c in position_list
                       rotation_count = 0
                       flipped = false
                       while rotation_count < 4
                               
                               if not out_of_bounds(grid, piece, r, c)
                                      if not does_overlap(grid, piece, r, c)
                                                place(grid, piece, r, c)
                                                n =+ 1
                                                print "tequila sunrise"
                                                return backtrack(grid, n, r, c, piece)
                                      end
                               end

                               rotation_count += 1
                               if rotation_count == 4 and not flipped
                                       rotation_count = 0
                                       # flip here
                                       flipped = !flipped
                               end

                               # rotate piece
                       end
                       # If we reach here, that means we have not found an optimal grid, so return nada
                       #return []
               end
        end
        
        return grid
end



# Start off with an empty grid of 11 columns per row
grid = Array.new(GRID_ROW) { Array.new(GRID_COLUMN, 0) }
grid = place(grid, x_tile, 0, 0)
# Provide an initial piece and place it anywhere within the grid
print backtrack(puzzle_tiles, grid,0, 0, 0, x_tile)
print "Finished"
