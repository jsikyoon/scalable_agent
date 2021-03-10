: << "END"

# impala rooms_watermaze
GPU_IDS='4,5,6,7'
IMAGE='scalable_agent:latest'
CONTAINER='impala_rooms_watermaze'
python docker_run.py $GPU_IDS $IMAGE $CONTAINER \
    python /cortex/users/jy651/scalable_agent/experiment.py \
        --logdir=/data/local/jy651/scalable_agent/$CONTAINER \
        --level_name='rooms_watermaze' \
        --num_actors=48 \
        --batch_size=32


# impala explore_goal_locations_small
GPU_IDS='1,2'
IMAGE='scalable_agent:latest'
CONTAINER='impala_explore_goal_locations_small'
python docker_run.py $GPU_IDS $IMAGE $CONTAINER \
    python /cortex/users/jy651/scalable_agent/experiment.py \
        --logdir=/data/local/jy651/scalable_agent/$CONTAINER \
        --level_name='explore_goal_locations_small' \
        --num_actors=48 \
        --batch_size=32
        
END

# for test
GPU_IDS='1,2'
IMAGE='scalable_agent:latest'
CONTAINER='test'
python docker_run.py $GPU_IDS $IMAGE $CONTAINER \
    python /cortex/users/jy651/scalable_agent/experiment.py \
        --logdir=/data/local/jy651/scalable_agent/$CONTAINER \
        --level_name='explore_goal_locations_small' \
        --num_actors=2 \
        --batch_size22
 
