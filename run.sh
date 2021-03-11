: << "END"

# impala lstm rooms_watermaze
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
        

# for test
GPU_IDS='4,5,6,7'
IMAGE='scalable_agent:latest'
CONTAINER='test'
python docker_run.py $GPU_IDS $IMAGE $CONTAINER \
    python /cortex/users/jy651/scalable_agent/experiment_trxl.py \
        --logdir=/data/local/jy651/scalable_agent/$CONTAINER \
        --pre_lnorm=False \
        --level_name='explore_goal_locations_small' \
        --num_actors=24 \
        --batch_size=12
 
END

# impala trxl rooms_watermaze
GPU_IDS='0,1,2,3'
IMAGE='scalable_agent:latest'
CONTAINER='impala_trxl_rooms_watermaze'
python docker_run.py $GPU_IDS $IMAGE $CONTAINER \
    python /cortex/users/jy651/scalable_agent/experiment_trxl.py \
        --logdir=/data/local/jy651/scalable_agent/$CONTAINER \
        --pre_lnorm=False \
        --level_name='rooms_watermaze' \
        --num_actors=24 \
        --batch_size=32

# impala trxl-i rooms_watermaze
GPU_IDS='4,5,6,7'
IMAGE='scalable_agent:latest'
CONTAINER='impala_trxli_rooms_watermaze'
python docker_run.py $GPU_IDS $IMAGE $CONTAINER \
    python /cortex/users/jy651/scalable_agent/experiment_trxl.py \
        --logdir=/data/local/jy651/scalable_agent/$CONTAINER \
        --pre_lnorm=True \
        --level_name='rooms_watermaze' \
        --num_actors=24 \
        --batch_size=32


