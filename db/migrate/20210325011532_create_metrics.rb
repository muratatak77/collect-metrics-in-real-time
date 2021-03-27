    		# {"txcount":80408,"netpeers":7387,"ingresscount":66831,
		# "egresscount":15429,"procload":25356,"sysload":41737,
		# "syswait":60631,"threads":11485,"writebytes":15026,
		# "readbytes":86413,"memallocs":3090,"memfrees":65194,
		# "mempauses":90563,"memused":12433}

class CreateMetrics < ActiveRecord::Migration[6.1]
  def change
    create_table :metrics do |t|
		t.integer :txcount
		t.integer :netpeers
		t.integer :ingresscount
		t.integer :egresscount
		t.integer :procload
		t.integer :sysload
		t.integer :syswait
		t.integer :threads
		t.integer :writebytes
		t.integer :readbytes
		t.integer :memallocs
		t.integer :memfrees
		t.integer :mempauses
		t.integer :memused
      	t.timestamps
    end
  end
end
